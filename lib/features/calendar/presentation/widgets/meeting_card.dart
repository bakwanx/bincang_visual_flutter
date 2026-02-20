import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/calendar_entities.dart';

class MeetingCard extends StatelessWidget {
  final ScheduledMeeting meeting;
  final VoidCallback onCancel;
  final VoidCallback onJoin;

  const MeetingCard({
    Key? key,
    required this.meeting,
    required this.onCancel,
    required this.onJoin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final now = DateTime.now();
    final canJoin = meeting.startTime.isBefore(now.add(const Duration(minutes: 15))) &&
        meeting.endTime.isAfter(now);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: canJoin ? onJoin : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meeting.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              '${timeFormat.format(meeting.startTime)} - ${timeFormat.format(meeting.endTime)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (canJoin)
                    Chip(
                      label: const Text('Join Now'),
                      backgroundColor: Colors.green.shade100,
                      labelStyle: TextStyle(color: Colors.green.shade700),
                    )
                  else if (meeting.isUpcoming)
                    Chip(
                      label: Text(_getTimeUntilText()),
                      backgroundColor: Colors.blue.shade50,
                    ),
                ],
              ),
              if (meeting.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  meeting.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (meeting.attendees.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.people, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${meeting.attendees.length} attendee${meeting.attendees.length > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  if (canJoin)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onJoin,
                        icon: const Icon(Icons.video_call, size: 18),
                        label: const Text('Join'),
                      ),
                    )
                  else
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Copy meeting link
                          // Clipboard.setData(ClipboardData(text: meeting.joinUrl));
                        },
                        icon: const Icon(Icons.link, size: 18),
                        label: const Text('Copy Link'),
                      ),
                    ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeUntilText() {
    final duration = meeting.timeUntilStart;
    if (duration.inHours > 0) {
      return 'In ${duration.inHours}h';
    } else if (duration.inMinutes > 0) {
      return 'In ${duration.inMinutes}m';
    } else {
      return 'Starting soon';
    }
  }
}