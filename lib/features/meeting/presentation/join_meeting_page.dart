import 'package:bincang_visual_flutter/features/meeting/presentation/cubit/meeting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'meeting_room_page.dart';

@Deprecated('we dont use this')
class JoinMeetingPage extends StatefulWidget {
  const JoinMeetingPage({Key? key}) : super(key: key);

  @override
  State<JoinMeetingPage> createState() => _JoinMeetingPageState();
}

class _JoinMeetingPageState extends State<JoinMeetingPage> {
  final _roomIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _roomIdController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Meeting')),
      body: BlocListener<MeetingCubit, MeetingState>(
        listener: (context, state) {
          if (state is MeetingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is MeetingJoined) {

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => MeetingRoomPage(
                      roomId: state.roomId,
                      // userId: 'user-${DateTime.now().millisecondsSinceEpoch}',
                      displayName: _nameController.text.trim(),
                    ),
              ),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    Icon(
                      Icons.video_call,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 32),


                    const Text(
                      'Join a Meeting',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Enter the meeting code or link',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),


                    TextFormField(
                      controller: _roomIdController,
                      decoration: InputDecoration(
                        labelText: 'Meeting Code or Link',
                        hintText: 'e.g., abc-def-ghi or full URL',
                        prefixIcon: const Icon(Icons.link),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.content_paste),
                          onPressed: _pasteFromClipboard,
                          tooltip: 'Paste from clipboard',
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a meeting code or link';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),


                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                        hintText: 'Enter your display name',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _joinMeeting(),
                    ),
                    const SizedBox(height: 24),


                    BlocBuilder<MeetingCubit, MeetingState>(
                      builder: (context, state) {
                        final isLoading = state is MeetingLoading;

                        return ElevatedButton(
                          onPressed: isLoading ? null : _joinMeeting,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child:
                              isLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : const Text(
                                    'Join Meeting',
                                    style: TextStyle(fontSize: 16),
                                  ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),


                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'You can paste a full meeting URL or just the room code',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null && clipboardData.text != null) {
      _roomIdController.text = clipboardData.text!;
    }
  }

  void _joinMeeting() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final input = _roomIdController.text.trim();
    final roomId = _extractRoomId(input);
    final displayName = _nameController.text.trim();

    context.read<MeetingCubit>().joinMeeting(
      roomId: roomId,

      displayName: displayName,
    );
  }

  String _extractRoomId(String input) {

    if (input.contains('http://') || input.contains('https://')) {
      final uri = Uri.parse(input);


      final pathSegments = uri.pathSegments;
      if (pathSegments.isNotEmpty) {
        return pathSegments.last;
      }
    }


    return input;
  }
}
