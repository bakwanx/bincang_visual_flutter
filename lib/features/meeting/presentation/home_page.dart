import 'package:bincang_visual_flutter/utils/extension/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/const/assets_path.dart';
import '../../../utils/extension/datetime_extension.dart';
import '../../../utils/format/datetime_util_format.dart';
import '../../../utils/theme/app_text_style.dart';
import 'cubit/meeting_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _meetingCodeController = TextEditingController();
  bool _isCreating = false;

  @override
  void dispose() {
    _meetingCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MeetingCubit, MeetingState>(
      listener: (context, state) {
        if (state is MeetingRoomCreated) {
          context.go('/preview', extra: {
            'roomId': state.roomId,
            'isNewMeeting': true,
          });

        } else if (state is MeetingError) {
          setState(() => _isCreating = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Image.asset(AssetsPath.icLogo, height: 24).rightMargin(8),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "Bincang ",
                        style: AppTextStyle.labelMedium.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        "Visual",
                        style: AppTextStyle.labelMedium.copyWith(
                          color: Color(0xff4b89ec),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            StreamBuilder(
              stream: Stream.periodic(Duration(minutes: 1)),
              builder: (ctx, snapshot) {
                return Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Text(
                    DateTime.now().asString(DateTimeUtilFormat.defaultFormat),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    "Meetings and video calls\nfor everyone",
                    style: AppTextStyle.bodyLarge.copyWith(
                      fontSize: 40,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Connect, collaborate, and celebrate from anywhere with Bincang Visual",
                    style: AppTextStyle.bodyLarge.copyWith(
                      fontSize: 20,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Join a Meeting',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _meetingCodeController,
                              decoration: InputDecoration(
                                labelText: 'Enter meeting code or link',
                                hintText: 'e.g., abc-def-ghi or paste link',
                                prefixIcon: const Icon(Icons.link),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.content_paste),
                                  onPressed: _pasteFromClipboard,
                                  tooltip: 'Paste',
                                ),
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a meeting code';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) => _joinMeeting(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _joinMeeting,
                            icon: const Icon(Icons.login),
                            label: const Text('Join Meeting'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 24),

                  OutlinedButton.icon(
                    onPressed: _isCreating ? null : _createNewMeeting,
                    icon:
                        _isCreating
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Icon(Icons.add),
                    label: Text(
                      _isCreating ? 'Creating...' : 'Create New Meeting',
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      _meetingCodeController.text = data!.text!;
    }
  }

  void _joinMeeting() {
    if (_formKey.currentState!.validate()) {
      final input = _meetingCodeController.text.trim();
      final roomId = _extractRoomId(input);

      context.go('/preview', extra: {
        'roomId': roomId,
        'isNewMeeting': true,
      });
    }
  }

  Future<void> _createNewMeeting() async {
    setState(() => _isCreating = true);

    context.read<MeetingCubit>().createRoom();
  }

  String _extractRoomId(String input) {
    if (input.contains('http') || input.contains('/')) {
      final uri = Uri.tryParse(input);
      if (uri != null) {
        final segments = uri.pathSegments;
        if (segments.isNotEmpty) {
          return segments.last;
        }
      }
    }
    return input;
  }
}
