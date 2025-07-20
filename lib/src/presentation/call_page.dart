import 'package:bincang_visual_flutter/src/domain/entities/call_entity.dart';
import 'package:bincang_visual_flutter/src/presentation/cubit/call_cubit.dart';
import 'package:bincang_visual_flutter/src/presentation/cubit/signaling_cubit.dart';
import 'package:bincang_visual_flutter/src/presentation/dashboard_page.dart';
import 'package:bincang_visual_flutter/utils/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../di/dependency_injection.dart';
import '../../utils/theme/app_colors.dart';

class CallPage extends StatelessWidget {
  final CallEntity callEntity;

  const CallPage({super.key, required this.callEntity});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => di<SignalingCubit>()..init(callEntity: callEntity),
        ),
        BlocProvider(
          create:
              (context) =>
                  di<CallCubit>()
                    ..init(callEntity.micEnabled, callEntity.cameraEnabled),
        ),
      ],
      child: CallPageUI(callEntity: callEntity),
    );
  }
}

class CallPageUI extends StatefulWidget {
  final CallEntity callEntity;

  const CallPageUI({super.key, required this.callEntity});

  @override
  State<CallPageUI> createState() => _CallPageUIState();
}

class _CallPageUIState extends State<CallPageUI> {

  void toggleChatPanel() {
    context.read<CallCubit>().setVisibleChat();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final signalingCubit = context.read<SignalingCubit>();
    signalingCubit.stream.listen((state) {
      if (mounted) {
        context.read<CallCubit>().setLocalStream(state.localStream);
      }
    });
  }

  void toggleMic() {
    final localStream = context.read<SignalingCubit>().state.localStream;
    if (localStream != null) {
      context.read<CallCubit>().setMic(localStream);
    }
  }

  void toggleCamera() {
    final localStream = context.read<SignalingCubit>().state.localStream;
    if (localStream != null) {
      context.read<CallCubit>().setCamera(localStream);
    }
  }

  void leaveRoom() {
    context.read<CallCubit>().leave();
    context.read<SignalingCubit>().leave();
    context.pushAndRemoveUntil(DashboardPage());
  }

  Widget participant() {
    return BlocBuilder<CallCubit, CallState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;
            final double screenHeight = constraints.maxHeight;
            final bool isPortrait = screenHeight > screenWidth;

            const double minTileWidth = 200;
            const double minTileHeight = 200;

            if (state.remoteRenderer.entries.length <= 2) {
              return state.remoteRenderer.entries.length == 1
                  ? _buildFullScreenParticipant(
                    state.remoteRenderer.entries.first.key,
                    state.remoteRenderer.entries.first.value,
                    false,
                  )
                  : (isPortrait
                      ? Column(
                        children:
                            state.remoteRenderer.entries.map((entry) {
                              return Expanded(
                                child: _buildParticipantTile(
                                  entry.key,
                                  entry.value,
                                ),
                              );
                            }).toList(),
                      )
                      : Row(
                        children:
                            state.remoteRenderer.entries.map((entry) {
                              return Expanded(
                                child: _buildParticipantTile(
                                  entry.key,
                                  entry.value,
                                ),
                              );
                            }).toList(),
                      ));
            }

            int columns = isPortrait ? 2 : 3;
            double tileWidth = screenWidth / columns;
            double tileHeight =
                screenHeight /
                ((state.remoteRenderer.entries.length / columns).ceil());

            if (tileWidth >= minTileWidth && tileHeight >= minTileHeight) {
              return Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children:
                    state.remoteRenderer.entries.map((entry) {
                      return SizedBox(
                        width: tileWidth - 8,
                        height: tileHeight - 8,
                        child: _buildParticipantTile(entry.key, entry.value),
                      );
                    }).toList(),
              );
            } else {
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isPortrait ? 2 : 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: isPortrait ? 3 / 4 : 4 / 3,
                ),
                itemCount: state.remoteRenderer.entries.length,
                itemBuilder: (context, index) {
                  // final entry = remoteRenderers.entries.toList()[0];
                  // final renderer = entry.value;
                  // final key = entry.key;
                  // // final isActive = participant.key == widget.activeSpeakerId;
                  // final isActive = false;
                  final participant = state.remoteRenderer.entries.elementAt(
                    index,
                  );
                  return _buildParticipantTile(
                    participant.key,
                    participant.value,
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  Widget _buildFullScreenParticipant(
    String id,
    RTCVideoRenderer renderer,
    bool isActive,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Container(
              color: Colors.black,
              child: RTCVideoView(
                renderer,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              ),
            ),
            if (isActive)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.greenAccent, width: 4),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  id,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantTile(String id, RTCVideoRenderer renderer) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Container(
              color: Colors.black,
              child: RTCVideoView(
                renderer,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              ),
            ),
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  id,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final callCubit = context.read<CallCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text('user: ${widget.callEntity.user.username}'),
        actions: [
          if (context.isPhone()) ...[
            IconButton(onPressed: toggleChatPanel, icon: Icon(Icons.message)),
          ],
        ],
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<CallCubit, CallState>(
        builder: (context, callState) {
          return BlocListener<SignalingCubit, SignalingState>(
            listenWhen:
                (previous, current) =>
                    previous.remoteStream != current.remoteStream,
            listener: (context, signalingState) {
              // Loop through the updated remote streams
              signalingState.remoteStream.forEach((key, stream) {
                callCubit.setRemoteStream(key, stream);
              });

              // Remove remote users who left
              callState.remoteRenderer.forEach((key, renderer) {
                if (!signalingState.remoteStream.containsKey(key)) {
                  callCubit.removeRemoteStream(key);
                }
              });
            },
            child: BlocBuilder<SignalingCubit, SignalingState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    participant(),

                    // Local Video
                    Positioned(
                      left: callState.x,
                      top: callState.y,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          context.read<CallCubit>().axisXY(details.delta.dx, details.delta.dy);
                        },
                        child: Container(
                          width: 120,
                          height: 160,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: RTCVideoView(
                              callState.localRenderer!,
                              mirror: true,
                              objectFit:
                                  RTCVideoViewObjectFit
                                      .RTCVideoViewObjectFitCover,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Bottom Buttons
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                              heroTag: 'mic',
                              backgroundColor:
                                  callState.micEnabled
                                      ? AppColors.secondaryColor
                                      : Colors.red,
                              onPressed: toggleMic,
                              child: Icon(
                                callState.micEnabled
                                    ? Icons.mic
                                    : Icons.mic_off,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 24),
                            FloatingActionButton(
                              heroTag: 'camera',
                              backgroundColor:
                                  callState.cameraEnabled
                                      ? AppColors.secondaryColor
                                      : Colors.red,
                              onPressed: toggleCamera,
                              child: Icon(
                                callState.cameraEnabled
                                    ? Icons.videocam
                                    : Icons.videocam_off,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 24),
                            FloatingActionButton(
                              heroTag: 'leave',
                              backgroundColor: Colors.redAccent,
                              onPressed: leaveRoom,
                              child: Icon(Icons.call_end),
                            ),
                          ],
                        ),
                      ),
                    ),

                    context.isTablet()
                        ? Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 24.0,
                              right: 24,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FloatingActionButton(
                                  heroTag: 'chat',
                                  backgroundColor: Colors.white,
                                  onPressed: toggleChatPanel,
                                  child: Icon(Icons.message),
                                ),
                              ],
                            ),
                          ),
                        )
                        : SizedBox(),
                    _DisplayChat(
                      toggleChatPanel: toggleChatPanel,
                      isChatVisible: callState.isChatVisible,
                      animationDuration: Duration(milliseconds: 300),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _DisplayChat extends StatefulWidget {
  final Function() toggleChatPanel;
  final Duration animationDuration;
  final bool isChatVisible;

  const _DisplayChat({
    super.key,
    required this.toggleChatPanel,
    required this.animationDuration,
    required this.isChatVisible,
  });

  @override
  State<_DisplayChat> createState() => _DisplayChatState();
}

class _DisplayChatState extends State<_DisplayChat> {
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double chatWidth =
        context.isTablet() ? screenWidth * 0.4 : context.width();
    return AnimatedPositioned(
      duration: widget.animationDuration,
      right: widget.isChatVisible ? 0 : -chatWidth,
      top: 0,
      bottom: 0,
      child: AnimatedContainer(
        duration: widget.animationDuration,
        width: chatWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
        ),
        child: Column(
          children: [
            AppBar(
              title: Text('Meeting Chat'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: widget.toggleChatPanel,
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<SignalingCubit, SignalingState>(
                builder: (context, state) {
                  return ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: state.chat.length,
                    itemBuilder:
                        (context, index) => Align(
                          alignment:
                              state.user!.id != state.chat[index].userFrom.id
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment:
                                state.user!.id != state.chat[index].userFrom.id
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.end,
                            children: [
                              Text(
                                state.chat[index].userFrom.username,
                                style: TextStyle(color: Colors.grey),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      state.user!.id !=
                                              state.chat[index].userFrom.id
                                          ? Colors.grey[300]
                                          : Colors.blue[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(state.chat[index].message),
                              ),
                            ],
                          ),
                        ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          context.read<SignalingCubit>().sendChat(
                            messageController.text,
                          );
                          messageController.clear();
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (messageController.text.isNotEmpty) {
                        context.read<SignalingCubit>().sendChat(
                          messageController.text,
                        );
                        messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
