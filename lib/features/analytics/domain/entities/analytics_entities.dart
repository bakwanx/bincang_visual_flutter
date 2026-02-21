import 'package:equatable/equatable.dart';

class UserAnalytics extends Equatable {
  final String userId;
  final int totalMeetings;
  final double totalDuration; // in hours
  final double averageDuration; // in minutes
  final int thisMonthMeetings;
  final List<double> weeklyData;
  final List<RecentMeeting> recentMeetings;

  const UserAnalytics({
    required this.userId,
    required this.totalMeetings,
    required this.totalDuration,
    required this.averageDuration,
    required this.thisMonthMeetings,
    required this.weeklyData,
    required this.recentMeetings,
  });

  @override
  List<Object?> get props => [
    userId,
    totalMeetings,
    totalDuration,
    averageDuration,
    thisMonthMeetings,
    weeklyData,
    recentMeetings,
  ];
}

class RecentMeeting extends Equatable {
  final String id;
  final String name;
  final String date;
  final int duration;

  const RecentMeeting({
    required this.id,
    required this.name,
    required this.date,
    required this.duration,
  });

  @override
  List<Object?> get props => [id, name, date, duration];
}