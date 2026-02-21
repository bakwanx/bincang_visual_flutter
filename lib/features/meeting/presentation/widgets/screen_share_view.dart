import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../domain/entities/meeting_entities.dart';

class ScreenShareView extends StatefulWidget {
  final String sharingUserId;
  final MediaStream screenStream;
  final List<Participant> participants;
  final VoidCallback? onClose;

  const ScreenShareView({
    Key? key,
    required this.sharingUserId,
    required this.screenStream,
    required this.participants,
     this.onClose,
  }) : super(key: key);

  @override
  State<ScreenShareView> createState() => _ScreenShareViewState();
}

class _ScreenShareViewState extends State<ScreenShareView> {
  final RTCVideoRenderer _renderer = RTCVideoRenderer();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initRenderer();
  }

  Future<void> _initRenderer() async {
    await _renderer.initialize();
    _renderer.srcObject = widget.screenStream;
    setState(() => _isInitialized = true);
  }

  @override
  void didUpdateWidget(ScreenShareView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.screenStream != oldWidget.screenStream) {
      _renderer.srcObject = widget.screenStream;
    }
  }

  @override
  void dispose() {
    _renderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sharingParticipant = widget.participants.firstWhere(
      (p) => p.userId == widget.sharingUserId,
      orElse:
          () => Participant(
            userId: widget.sharingUserId,
            roomId: '',
            displayName: 'Someone',
            joinedAt: DateTime.now(),
          ),
    );

    return Stack(
      children: [
        if (_isInitialized)
          RTCVideoView(
            _renderer,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
            mirror: false,
          )
        else
          const Center(child: CircularProgressIndicator()),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  const Icon(Icons.screen_share, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${sharingParticipant.displayName} is sharing',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
