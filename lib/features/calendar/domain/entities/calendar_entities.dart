import 'package:equatable/equatable.dart';

class ScheduledMeeting extends Equatable {
  final String id;
  final String roomId;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> attendees;
  final String googleEventId;
  final String creatorId;
  final String joinUrl;

  const ScheduledMeeting({
    required this.id,
    required this.roomId,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.attendees,
    required this.googleEventId,
    required this.creatorId,
    required this.joinUrl,
  });

  @override
  List<Object?> get props => [
    id,
    roomId,
    title,
    description,
    startTime,
    endTime,
    attendees,
    googleEventId,
    creatorId,
    joinUrl,
  ];

  bool get isUpcoming => startTime.isAfter(DateTime.now());
  bool get isToday {
    final now = DateTime.now();
    return startTime.year == now.year &&
        startTime.month == now.month &&
        startTime.day == now.day;
  }

  Duration get timeUntilStart => startTime.difference(DateTime.now());
}