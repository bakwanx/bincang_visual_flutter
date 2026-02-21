import 'package:bincang_visual_flutter/features/meeting/presentation/cubit/meeting_cubit.dart';
import 'package:bincang_visual_flutter/features/meeting/presentation/widgets/chat_panel.dart';
import 'package:bincang_visual_flutter/features/meeting/presentation/widgets/meeting_controls.dart';
import 'package:bincang_visual_flutter/features/meeting/presentation/widgets/participant_grid.dart';
import 'package:bincang_visual_flutter/features/meeting/presentation/widgets/participants_panel.dart';
import 'package:bincang_visual_flutter/features/meeting/presentation/widgets/screen_share_view.dart';
import 'package:bincang_visual_flutter/features/meeting/presentation/widgets/video_renderer_widget.dart';
import 'package:bincang_visual_flutter/utils/extension/null_helper_extenison.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../utils/extension/context_extension.dart';
import '../domain/entities/meeting_entities.dart';

class MeetingRoomPage extends StatefulWidget {
  final String roomId;
  final String displayName;
  final bool initialCameraState;
  final bool initialMicState;

  const MeetingRoomPage({
    Key? key,
    required this.roomId,
    required this.displayName,
    this.initialCameraState = true,
    this.initialMicState = true,
  }) : super(key: key);

  @override
  State<MeetingRoomPage> createState() => _MeetingRoomPageState();
}

class _MeetingRoomPageState extends State<MeetingRoomPage> {
  bool _showChat = false;
  bool _showParticipants = false;

  @override
  void initState() {
    super.initState();
    _joinMeeting();
  }

  Future<void> _joinMeeting() async {
    final cubit = context.read<MeetingCubit>();

    await cubit.joinMeeting(
      roomId: widget.roomId,
      displayName: widget.displayName,
    );

    if (!widget.initialCameraState) {
      await cubit.toggleVideo();
    }
    if (!widget.initialMicState) {
      await cubit.toggleMute();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldLeave = await _showLeaveConfirmation();
        if (shouldLeave) {
          await context.read<MeetingCubit>().leaveMeeting();
        }
        return shouldLeave;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocConsumer<MeetingCubit, MeetingState>(
          listener: (context, state) {
            if (state is MeetingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is MeetingEnded) {
              context.go('/');
            }
          },
          builder: (context, state) {
            if (state is MeetingLoading) {
              return _buildLoadingState(state);
            }

            if (state is MeetingJoined) {
              return _buildMeetingRoom(context, state);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState(MeetingLoading state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          if (state.message != null) ...[
            const SizedBox(height: 16),
            Text(state.message!, style: const TextStyle(color: Colors.white70)),
          ],
        ],
      ),
    );
  }

  Widget _buildMeetingRoom(BuildContext context, MeetingJoined state) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isAnyoneSharing = state.screenShareStreams.isNotEmpty;
    final sharingEntry =
        isAnyoneSharing ? state.screenShareStreams.entries.first : null;
    final someoneElseIsSharing = state.participants.any(
      (p) => p.userId != state.localUserId && p.isScreenSharing,
    );

    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            children: [
              Expanded(
                child:
                    isAnyoneSharing
                        ? _buildScreenShareView(state, sharingEntry!)
                        : _buildParticipantGridView(state),
              ),

              if (isAnyoneSharing) _buildParticipantStrip(state),

              const SizedBox(height: 80),
            ],
          ),
        ),

        Positioned(top: 0, right: 0, child: _buildTopBar(state)),

        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(
            child: MeetingControls(
              isMuted: state.isMuted,
              isVideoOff: state.isVideoOff,
              isScreenSharing: state.isScreenSharing,
              someoneElseIsSharing: someoneElseIsSharing,
              onToggleMute: () => context.read<MeetingCubit>().toggleMute(),
              onToggleVideo: () => context.read<MeetingCubit>().toggleVideo(),
              onToggleScreenShare: () {
                if (state.isScreenSharing) {
                  context.read<MeetingCubit>().stopScreenShare();
                } else {
                  context.read<MeetingCubit>().startScreenShare();
                  // return;
                  // if (kIsWeb) {
                  //   context.read<MeetingCubit>().startScreenShare();
                  // } else {
                  //   _showScreenShareNotSupported();
                  // }
                }
              },
              onToggleChat: () => setState(() => _showChat = !_showChat),
              onToggleParticipants:
                  () => setState(() => _showParticipants = !_showParticipants),
              onLeaveMeeting: () async {
                final shouldLeave = await _showLeaveConfirmation();
                if (shouldLeave) {
                  context.read<MeetingCubit>().leaveMeeting();
                }
              },
              onSwitchCamera:
                  isMobile
                      ? () => context.read<MeetingCubit>().switchCamera()
                      : null,
            ),
          ),
        ),

        if (_showChat)
          Positioned(
            right: isMobile ? 0 : 20,
            bottom: isMobile ? 0 : 20,
            top: isMobile ? null : 20,
            width: isMobile ? context.width() : 320,
            height: isMobile ? context.height() : null,
            child: ChatPanel(
              messages: state.chatMessages,
              onSendMessage: (message) {
                context.read<MeetingCubit>().sendChatMessage(message);
              },
              onClose: () => setState(() => _showChat = false),
              currentUserId: state.localUserId,
            ),
          ),

        if (_showParticipants)
          Positioned(
            right: isMobile ? 0 : (_showChat ? 360 : 20),
            bottom: isMobile ? 0 : 20,
            top: isMobile ? null : 20,
            width: isMobile ? MediaQuery.of(context).size.width : 280,
            height: isMobile ? context.height() : null,
            child: ParticipantsPanel(
              participants: state.participants,
              onClose: () => setState(() => _showParticipants = false),
            ),
          ),
      ],
    );
  }

  Widget _buildScreenShareView(
    MeetingJoined state,
    MapEntry<String, MediaStream> sharingEntry,
  ) {
    return ScreenShareView(
      sharingUserId: sharingEntry.key,
      screenStream: sharingEntry.value,
      participants: state.participants,
      onClose: null,
    );
  }

  Widget _buildParticipantGridView(MeetingJoined state) {
    return ParticipantGrid(
      localStream: state.localStream,
      remoteStreams: state.remoteStreams,
      participants: state.participants,
      localUserId: state.localUserId,
    );
  }

  Widget _buildParticipantStrip(MeetingJoined state) {
    final allParticipants = [
      Participant(
        userId: state.localUserId,
        roomId: state.roomId,
        displayName: 'You',
        joinedAt: DateTime.now(),
        isMuted: state.isMuted,
        isVideoOff: state.isVideoOff,
      ),
      ...state.participants.where((p) => p.userId != state.localUserId),
    ];

    return Container(
      height: 100,
      color: Colors.black.withOpacity(0.8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemCount: allParticipants.length,
        itemBuilder: (context, index) {
          final participant = allParticipants[index];
          final isLocal = participant.userId == state.localUserId;
          final stream = isLocal
              ? state.localStream
              : state.remoteStreams[participant.userId];

          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 8),
            child: _buildCompactVideoCard(
              stream: stream,
              participant: participant,
              isLocal: isLocal,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompactVideoCard({
    required MediaStream? stream,
    required Participant participant,
    required bool isLocal,
  }) {
    if (stream != null && !participant.isVideoOff) {
      return VideoRendererWidget(
        key: ValueKey('strip_${participant.userId}_${stream.id}'),
        stream: stream,
        isMirrored: isLocal,
        isLocal: isLocal,
        participantName: participant.displayName,
        isMuted: participant.isMuted,
        isVideoOff: false,
      );
    } else {
      return _buildCompactPlaceholder(participant);
    }
  }

  Widget _buildCompactPlaceholder(Participant participant) {
    return Container(
      color: Colors.grey.shade900,
      child: Center(
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue,
          child: Text(
            participant.displayName.isNotEmpty
                ? participant.displayName[0].toUpperCase()
                : 'U',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(MeetingJoined state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withOpacity(0.7), Colors.transparent],
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (state.roomInfo != null) ...[
              const Icon(Icons.videocam, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                state.roomInfo!.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            if (state.roomInfo!.isRecording)... {
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.fiber_manual_record,
                      color: Colors.white,
                      size: 12,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Recording',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            }
          ],
        ),
      ),
    );
  }

  Future<bool> _showLeaveConfirmation() async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Leave Meeting?'),
                content: const Text(
                  'Are you sure you want to leave this meeting?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => context.pop(false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => context.pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Leave'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  void _showScreenShareNotSupported() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Screen Share Not Available'),
            content: const Text(
              'Screen sharing is currently only available on web platform.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
