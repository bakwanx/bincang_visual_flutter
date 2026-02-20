import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoRendererWidget extends StatefulWidget {
  final MediaStream? stream;
  final bool isMirrored;
  final bool isLocal;
  final String? participantName;
  final bool isMuted;
  final bool isVideoOff;
  final VoidCallback? onTap;

  const VideoRendererWidget({
    Key? key,
    this.stream,
    this.isMirrored = false,
    this.isLocal = false,
    this.participantName,
    this.isMuted = false,
    this.isVideoOff = false,
    this.onTap,
  }) : super(key: key);

  @override
  State<VideoRendererWidget> createState() => _VideoRendererWidgetState();
}

class _VideoRendererWidgetState extends State<VideoRendererWidget> {
  final RTCVideoRenderer _renderer = RTCVideoRenderer();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didUpdateWidget(VideoRendererWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      _updateStream();
    }
  }

  Future<void> _initialize() async {
    await _renderer.initialize();
    setState(() => _isInitialized = true);
    _updateStream();
  }

  void _updateStream() {
    if (_isInitialized && widget.stream != null) {
      _renderer.srcObject = widget.stream;
    }
  }

  @override
  void dispose() {
    _renderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isLocal ? Colors.blue : Colors.grey.shade800,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (widget.isVideoOff || widget.stream == null)
                _buildVideoOffPlaceholder()
              else
                RTCVideoView(
                  _renderer,
                  mirror: widget.isMirrored,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),

              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: _buildInfoOverlay(),
              ),

              if (!widget.isLocal)
                Positioned(
                  top: 8,
                  right: 8,
                  child: _buildNetworkQualityIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoOffPlaceholder() {
    return Container(
      color: Colors.grey.shade900,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey.shade700,
              child: Text(
                _getInitials(widget.participantName ?? 'U'),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            if (widget.participantName != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.participantName!,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoOverlay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.isMuted)
            const Icon(Icons.mic_off, size: 16, color: Colors.red),
          if (widget.isMuted) const SizedBox(width: 4),
          Flexible(
            child: Text(
              widget.participantName ??
                  (widget.isLocal ? 'You' : 'Participant'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkQualityIndicator() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(
        Icons.signal_cellular_4_bar,
        size: 16,
        color: Colors.green,
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
