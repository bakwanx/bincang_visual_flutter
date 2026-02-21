import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _cameraEnabled = true;
  bool _microphoneEnabled = true;
  bool _notificationsEnabled = true;
  bool _autoJoinAudio = true;
  bool _hdVideo = false;
  String _selectedCamera = 'Front Camera';
  String _selectedMicrophone = 'Default';
  String _selectedSpeaker = 'Default';

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _checkPermissions();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _cameraEnabled = prefs.getBool('camera_enabled') ?? true;
      _microphoneEnabled = prefs.getBool('microphone_enabled') ?? true;
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _autoJoinAudio = prefs.getBool('auto_join_audio') ?? true;
      _hdVideo = prefs.getBool('hd_video') ?? false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('camera_enabled', _cameraEnabled);
    await prefs.setBool('microphone_enabled', _microphoneEnabled);
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setBool('auto_join_audio', _autoJoinAudio);
    await prefs.setBool('hd_video', _hdVideo);
  }

  Future<void> _checkPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final micStatus = await Permission.microphone.status;

    setState(() {
      _cameraEnabled = cameraStatus.isGranted;
      _microphoneEnabled = micStatus.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            'Audio & Video',
            [
              SwitchListTile(
                title: const Text('Camera'),
                subtitle: const Text('Enable camera for video calls'),
                value: _cameraEnabled,
                onChanged: (value) async {
                  if (value) {
                    final status = await Permission.camera.request();
                    if (status.isGranted) {
                      setState(() => _cameraEnabled = true);
                      _saveSettings();
                    }
                  } else {
                    setState(() => _cameraEnabled = false);
                    _saveSettings();
                  }
                },
              ),
              SwitchListTile(
                title: const Text('Microphone'),
                subtitle: const Text('Enable microphone for audio'),
                value: _microphoneEnabled,
                onChanged: (value) async {
                  if (value) {
                    final status = await Permission.microphone.request();
                    if (status.isGranted) {
                      setState(() => _microphoneEnabled = true);
                      _saveSettings();
                    }
                  } else {
                    setState(() => _microphoneEnabled = false);
                    _saveSettings();
                  }
                },
              ),
              SwitchListTile(
                title: const Text('HD Video'),
                subtitle: const Text('Use 1080p video (requires more bandwidth)'),
                value: _hdVideo,
                onChanged: (value) {
                  setState(() => _hdVideo = value);
                  _saveSettings();
                },
              ),
              SwitchListTile(
                title: const Text('Auto-join Audio'),
                subtitle: const Text('Automatically join with audio enabled'),
                value: _autoJoinAudio,
                onChanged: (value) {
                  setState(() => _autoJoinAudio = value);
                  _saveSettings();
                },
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            'Notifications',
            [
              SwitchListTile(
                title: const Text('Meeting Notifications'),
                subtitle: const Text('Get notified about upcoming meetings'),
                value: _notificationsEnabled,
                onChanged: (value) async {
                  if (value) {
                    final status = await Permission.notification.request();
                    if (status.isGranted) {
                      setState(() => _notificationsEnabled = true);
                      _saveSettings();
                    }
                  } else {
                    setState(() => _notificationsEnabled = false);
                    _saveSettings();
                  }
                },
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            'Account',
            [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                subtitle: const Text('View and edit your profile'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to profile page
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: () => _confirmSignOut(),
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            'About',
            [
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Version'),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () {
                  // Open privacy policy
                },
              ),
              ListTile(
                leading: const Icon(Icons.article),
                title: const Text('Terms of Service'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () {
                  // Open terms of service
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  void _confirmSignOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Perform sign out
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}