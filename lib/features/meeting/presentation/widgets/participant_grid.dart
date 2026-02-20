import 'package:bincang_visual_flutter/features/meeting/domain/entities/meeting_entities.dart';
import 'package:bincang_visual_flutter/utils/extension/list_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'video_renderer_widget.dart';

class ParticipantGrid extends StatelessWidget {
  final MediaStream? localStream;
  final Map<String, MediaStream> remoteStreams;
  final List<Participant> participants;
  final String localUserId;

  const ParticipantGrid({
    Key? key,
    this.localStream,
    required this.remoteStreams,
    required this.participants,
    required this.localUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalParticipants = 1 + remoteStreams.length;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return LayoutBuilder(
      builder: (context, constraints) {
        final gridConfig = _getGridConfiguration(
          totalParticipants,
          constraints,
          isMobile,
          isTablet,
        );

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridConfig.crossAxisCount,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: gridConfig.aspectRatio,
          ),
          itemCount: totalParticipants,
          itemBuilder: (context, index) {
            if (index == 0) {
              final localParticipant = participants.firstWhereOrNull(
                (p) => p.userId == localUserId,
              );

              return VideoRendererWidget(
                stream: localStream,
                isMirrored: true,
                isLocal: true,
                participantName: localParticipant?.displayName ?? 'You',
                isMuted: localParticipant?.isMuted ?? false,
                isVideoOff: localParticipant?.isVideoOff ?? false,
              );
            } else {
              final remoteIndex = index - 1;
              final peerId = remoteStreams.keys.elementAt(remoteIndex);
              final stream = remoteStreams[peerId];

              print(
                '[ParticipantGrid] Looking up participant for peerId: $peerId',
              );
              final participant = _findParticipant(peerId, participants);

              return VideoRendererWidget(
                stream: stream,
                participantName: participant.displayName,
                isMuted: participant.isMuted,
                isVideoOff: participant.isVideoOff,
              );
            }
          },
        );
      },
    );
  }

  _GridConfiguration _getGridConfiguration(
    int participantCount,
    BoxConstraints constraints,
    bool isMobile,
    bool isTablet,
  ) {
    if (isMobile) {
      if (participantCount == 1) {
        return _GridConfiguration(crossAxisCount: 1, aspectRatio: 9 / 16);
      } else if (participantCount == 2) {
        return _GridConfiguration(crossAxisCount: 1, aspectRatio: 16 / 9);
      } else {
        return _GridConfiguration(crossAxisCount: 2, aspectRatio: 4 / 3);
      }
    }

    if (isTablet) {
      if (participantCount <= 2) {
        return _GridConfiguration(crossAxisCount: 2, aspectRatio: 16 / 9);
      } else if (participantCount <= 6) {
        return _GridConfiguration(crossAxisCount: 3, aspectRatio: 4 / 3);
      } else {
        return _GridConfiguration(crossAxisCount: 3, aspectRatio: 16 / 9);
      }
    }

    if (participantCount == 1) {
      return _GridConfiguration(crossAxisCount: 1, aspectRatio: 16 / 9);
    } else if (participantCount == 2) {
      return _GridConfiguration(crossAxisCount: 2, aspectRatio: 16 / 9);
    } else if (participantCount <= 4) {
      return _GridConfiguration(crossAxisCount: 2, aspectRatio: 4 / 3);
    } else if (participantCount <= 9) {
      return _GridConfiguration(crossAxisCount: 3, aspectRatio: 4 / 3);
    } else {
      return _GridConfiguration(crossAxisCount: 4, aspectRatio: 16 / 9);
    }
  }

  Participant _findParticipant(String peerId, List<Participant> participants) {
    var participant = participants.firstWhereOrNull((p) => p.userId == peerId);
    if (participant != null) {
      return participant;
    }

    if (participants.length == 2) {
      participant = participants.firstWhereOrNull(
        (p) => p.userId != localUserId,
      );
      if (participant != null) {
        return participant;
      }
    }

    return Participant(
      userId: peerId,
      roomId: '',
      displayName: 'Participant',
      joinedAt: DateTime.now(),
    );
  }
}

class _GridConfiguration {
  final int crossAxisCount;
  final double aspectRatio;

  _GridConfiguration({required this.crossAxisCount, required this.aspectRatio});
}
