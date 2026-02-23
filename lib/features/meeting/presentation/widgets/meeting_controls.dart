import 'package:flutter/material.dart';

import '../../../../utils/platform_helper.dart';

class MeetingControls extends StatelessWidget {
  final bool isMuted;
  final bool isVideoOff;
  final bool isScreenSharing;
  final VoidCallback onToggleMute;
  final VoidCallback onToggleVideo;
  final VoidCallback onToggleScreenShare;
  final VoidCallback onToggleChat;
  final VoidCallback onToggleParticipants;
  final VoidCallback onLeaveMeeting;
  final VoidCallback? onSwitchCamera;
  final bool someoneElseIsSharing;

  const MeetingControls({
    Key? key,
    required this.isMuted,
    required this.isVideoOff,
    required this.isScreenSharing,
    required this.onToggleMute,
    required this.onToggleVideo,
    required this.onToggleScreenShare,
    required this.onToggleChat,
    required this.onToggleParticipants,
    required this.onLeaveMeeting,
    this.onSwitchCamera,
    required this.someoneElseIsSharing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final canScreenShare = PlatformHelper.supportsScreenShare;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(48),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildControlButton(
              icon: isMuted ? Icons.mic_off : Icons.mic,
              color: isMuted ? Colors.red : Colors.white,
              onPressed: onToggleMute,
              tooltip: isMuted ? 'Unmute' : 'Mute',
            ),

            const SizedBox(width: 12),

            _buildControlButton(
              icon: isVideoOff ? Icons.videocam_off : Icons.videocam,
              color: isVideoOff ? Colors.red : Colors.white,
              onPressed: onToggleVideo,
              tooltip: isVideoOff ? 'Start Video' : 'Stop Video',
            ),

            const SizedBox(width: 12),

            if (canScreenShare) ...[
              _buildControlButton(
                icon:
                    isScreenSharing
                        ? Icons.stop_screen_share
                        : Icons.screen_share,
                color:
                    isScreenSharing
                        ? Colors.green
                        : someoneElseIsSharing
                        ? Colors.grey
                        : Colors.white,
                onPressed:
                    someoneElseIsSharing && !isScreenSharing
                        ? null
                        : onToggleScreenShare,
                tooltip:
                    someoneElseIsSharing && !isScreenSharing
                        ? 'Someone else is sharing'
                        : isScreenSharing
                        ? 'Stop Sharing'
                        : 'Share Screen',
              ),
            ],

            const SizedBox(width: 12),

            _buildControlButton(
              icon: Icons.chat,
              color: Colors.white,
              onPressed: onToggleChat,
              tooltip: 'Chat',
            ),

            const SizedBox(width: 12),

            _buildControlButton(
              icon: Icons.people,
              color: Colors.white,
              onPressed: onToggleParticipants,
              tooltip: 'Participants',
            ),

            if (onSwitchCamera != null) ...[
              const SizedBox(width: 12),
              _buildControlButton(
                icon: Icons.flip_camera_ios,
                color: Colors.white,
                onPressed: onSwitchCamera!,
                tooltip: 'Switch Camera',
              ),
            ],

            const SizedBox(width: 12),

            _buildControlButton(
              icon: Icons.call_end,
              color: Colors.red,
              onPressed: onLeaveMeeting,
              tooltip: 'Leave Meeting',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Opacity(
            opacity: onPressed == null ? 0.5 : 1.0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
          ),
        ),
      ),
    );
  }
}
