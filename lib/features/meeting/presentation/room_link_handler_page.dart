import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/meeting_cubit.dart';
import 'meeting_preview_page.dart';

class RoomLinkHandlerPage extends StatefulWidget {
  final String roomId;

  const RoomLinkHandlerPage({Key? key, required this.roomId}) : super(key: key);

  @override
  State<RoomLinkHandlerPage> createState() => _RoomLinkHandlerPageState();
}

class _RoomLinkHandlerPageState extends State<RoomLinkHandlerPage> {
  @override
  void initState() {
    super.initState();
    _validateRoom();
  }

  Future<void> _validateRoom() async {
    final cubit = context.read<MeetingCubit>();
    await cubit.validateRoom(roomId: widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<MeetingCubit, MeetingState>(
        listener: (context, state) {
          if (state is RoomValidated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder:
                    (context) => MeetingPreviewPage(
                      roomId: widget.roomId,
                      isNewMeeting: false,
                    ),
              ),
            );
          } else if (state is MeetingError) {
            _showErrorDialog(state.message);
          }
        },
        builder: (context, state) {
          if (state is MeetingLoading) {
            return _buildLoadingState(state.message);
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildLoadingState(String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          const SizedBox(height: 16),
          Text(
            message ?? 'Validating room...',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Room Not Found'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
