import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeetingPreviewPage extends StatefulWidget {
  final String roomId;
  final bool isNewMeeting;

  const MeetingPreviewPage({
    Key? key,
    required this.roomId,
    required this.isNewMeeting,
  }) : super(key: key);

  @override
  State<MeetingPreviewPage> createState() => _MeetingPreviewPageState();
}

class _MeetingPreviewPageState extends State<MeetingPreviewPage> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  MediaStream? _previewStream;
  final RTCVideoRenderer _previewRenderer = RTCVideoRenderer();

  bool _isCameraOn = true;
  bool _isMicOn = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initPreview();
    _loadSavedName();
  }

  Future<void> _initPreview() async {
    try {
      await _previewRenderer.initialize();
      await _startPreview();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to access camera/microphone';
      });
    }
  }

  Future<void> _startPreview() async {
    try {
      final stream = await navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': {
          'facingMode': 'user',
          'width': {'ideal': 1280},
          'height': {'ideal': 720},
        },
      });

      setState(() {
        _previewStream = stream;
        _previewRenderer.srcObject = stream;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Camera/microphone access denied';
      });
    }
  }

  Future<void> _loadSavedName() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('user_display_name');
    if (savedName != null) {
      _nameController.text = savedName;
    }
  }

  Future<void> _saveName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_display_name', _nameController.text.trim());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _previewRenderer.dispose();
    _previewStream?.getTracks().forEach((track) {
      track.stop();
    });
    _previewStream?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isNewMeeting ? 'Setup Your Meeting' : 'Join Meeting',
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildPreview(),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _toggleCamera,
                    icon: Icon(
                      _isCameraOn ? Icons.videocam : Icons.videocam_off,
                    ),
                    iconSize: 32,
                    style: IconButton.styleFrom(
                      backgroundColor: _isCameraOn ? Colors.blue : Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(width: 16),

                  IconButton(
                    onPressed: _toggleMicrophone,
                    icon: Icon(_isMicOn ? Icons.mic : Icons.mic_off),
                    iconSize: 32,
                    style: IconButton.styleFrom(
                      backgroundColor: _isMicOn ? Colors.blue : Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                    hintText: 'Enter your display name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 24),

              if (widget.isNewMeeting) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Meeting Link',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _getMeetingLink(),
                                style: TextStyle(color: Colors.blue.shade700),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: _copyMeetingLink,
                              tooltip: 'Copy link',
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Share this link with participants',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              ElevatedButton.icon(
                onPressed: _isLoading ? null : _joinMeeting,
                icon:
                    _isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.video_call),
                label: Text(widget.isNewMeeting ? 'Start Meeting' : 'Join Now'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreview() {
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_previewStream == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_isCameraOn) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.blue,
              child: Text(
                _nameController.text.isNotEmpty
                    ? _nameController.text[0].toUpperCase()
                    : 'U',
                style: const TextStyle(fontSize: 32, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Camera is off', style: TextStyle(color: Colors.white)),
          ],
        ),
      );
    }

    return RTCVideoView(
      _previewRenderer,
      mirror: true,
      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
    );
  }

  void _toggleCamera() {
    setState(() {
      _isCameraOn = !_isCameraOn;
    });

    _previewStream?.getVideoTracks().forEach((track) {
      track.enabled = _isCameraOn;
    });
  }

  void _toggleMicrophone() {
    setState(() {
      _isMicOn = !_isMicOn;
    });

    _previewStream?.getAudioTracks().forEach((track) {
      track.enabled = _isMicOn;
    });
  }

  String _getMeetingLink() {
    return 'https://bincang-visual.com/room/${widget.roomId}';
  }

  void _copyMeetingLink() {
    Clipboard.setData(ClipboardData(text: _getMeetingLink()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meeting link copied to clipboard')),
    );
  }

  Future<void> _joinMeeting() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await _saveName();
    final displayName = _nameController.text.trim();

    _previewStream?.getTracks().forEach((track) {
      track.stop();
    });
    await _previewStream?.dispose();
    _previewStream = null;

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      '/meeting',
      arguments: {
        'roomId': widget.roomId,
        'userId': 'user-${DateTime.now().millisecondsSinceEpoch}',
        'displayName': displayName,
        'isNewMeeting': widget.isNewMeeting,
        'initialCameraState': _isCameraOn,
        'initialMicState': _isMicOn,
      },
    );
  }
}
