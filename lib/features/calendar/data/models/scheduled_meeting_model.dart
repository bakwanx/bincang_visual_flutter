import '../../domain/entities/calendar_entities.dart';

class ScheduledMeetingModel extends ScheduledMeeting {
  const ScheduledMeetingModel({
    required String id,
    required String roomId,
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
    required List<String> attendees,
    required String googleEventId,
    required String creatorId,
    required String joinUrl,
  }) : super(
    id: id,
    roomId: roomId,
    title: title,
    description: description,
    startTime: startTime,
    endTime: endTime,
    attendees: attendees,
    googleEventId: googleEventId,
    creatorId: creatorId,
    joinUrl: joinUrl,
  );

  factory ScheduledMeetingModel.fromJson(Map<String, dynamic> json) {
    return ScheduledMeetingModel(
      id: json['id'] as String,
      roomId: json['roomId'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      attendees: List<String>.from(json['attendees'] ?? []),
      googleEventId: json['googleEventId'] as String? ?? '',
      creatorId: json['creatorId'] as String? ?? '',
      joinUrl: json['joinUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'attendees': attendees,
      'googleEventId': googleEventId,
      'creatorId': creatorId,
      'joinUrl': joinUrl,
    };
  }
}