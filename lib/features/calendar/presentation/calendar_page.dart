import 'package:bincang_visual_flutter/features/calendar/presentation/widgets/meeting_card.dart';
import 'package:bincang_visual_flutter/features/calendar/presentation/widgets/schedule_meeting_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../domain/entities/calendar_entities.dart';
import 'cubit/calendar_cubit.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
    super.initState();
    context.read<CalendarCubit>().loadUpcomingMeetings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Meetings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CalendarCubit>().loadUpcomingMeetings();
            },
          ),
        ],
      ),
      body: BlocConsumer<CalendarCubit, CalendarState>(
        listener: (context, state) {
          if (state is CalendarError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is MeetingScheduled) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Meeting scheduled successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CalendarLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CalendarLoaded) {
            if (state.meetings.isEmpty) {
              return _buildEmptyState();
            }

            return _buildMeetingsList(state.meetings);
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showScheduleMeetingDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Schedule'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No scheduled meetings',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the button below to schedule a meeting',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingsList(List<ScheduledMeeting> meetings) {
    // Group meetings by date
    final groupedMeetings = <String, List<ScheduledMeeting>>{};
    for (var meeting in meetings) {
      final dateKey = DateFormat('yyyy-MM-dd').format(meeting.startTime);
      groupedMeetings.putIfAbsent(dateKey, () => []).add(meeting);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedMeetings.length,
      itemBuilder: (context, index) {
        final dateKey = groupedMeetings.keys.elementAt(index);
        final dateMeetings = groupedMeetings[dateKey]!;
        final date = DateTime.parse(dateKey);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                _formatDateHeader(date),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...dateMeetings.map((meeting) => MeetingCard(
              meeting: meeting,
              onCancel: () => _confirmCancelMeeting(meeting),
              onJoin: () => _joinMeeting(meeting),
            )),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final meetingDate = DateTime(date.year, date.month, date.day);

    if (meetingDate == today) {
      return 'Today';
    } else if (meetingDate == tomorrow) {
      return 'Tomorrow';
    } else {
      return DateFormat('EEEE, MMMM d').format(date);
    }
  }

  void _showScheduleMeetingDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => ScheduleMeetingDialog(
        onSchedule: (title, description, startTime, endTime, attendees) {
          context.read<CalendarCubit>().createScheduledMeeting(
            title: title,
            description: description,
            startTime: startTime,
            endTime: endTime,
            attendees: attendees,
          );
        },
      ),
    );
  }

  void _confirmCancelMeeting(ScheduledMeeting meeting) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Meeting'),
        content: Text('Are you sure you want to cancel "${meeting.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<CalendarCubit>().cancelScheduledMeeting(meeting.googleEventId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _joinMeeting(ScheduledMeeting meeting) {
    // Navigate to meeting room
    Navigator.pushNamed(
      context,
      '/meeting',
      arguments: {
        'roomId': meeting.roomId,
        'displayName': 'User', // Get from auth
      },
    );
  }
}