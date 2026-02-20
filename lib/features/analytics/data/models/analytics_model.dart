import '../../domain/entities/analytics_entities.dart';

class UserAnalyticsModel extends UserAnalytics {
  const UserAnalyticsModel({
    required String userId,
    required int totalMeetings,
    required double totalDuration,
    required double averageDuration,
    required int thisMonthMeetings,
    required List<double> weeklyData,
    required List<RecentMeeting> recentMeetings,
  }) : super(
    userId: userId,
    totalMeetings: totalMeetings,
    totalDuration: totalDuration,
    averageDuration: averageDuration,
    thisMonthMeetings: thisMonthMeetings,
    weeklyData: weeklyData,
    recentMeetings: recentMeetings,
  );

  factory UserAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return UserAnalyticsModel(
      userId: json['userId'] as String,
      totalMeetings: json['totalMeetings'] as int? ?? 0,
      totalDuration: (json['totalDuration'] as num?)?.toDouble() ?? 0.0,
      averageDuration: (json['averageDuration'] as num?)?.toDouble() ?? 0.0,
      thisMonthMeetings: json['thisMonthMeetings'] as int? ?? 0,
      weeklyData: (json['weeklyData'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
          [0, 0, 0, 0, 0, 0, 0],
      recentMeetings: (json['recentMeetings'] as List<dynamic>?)
          ?.map((e) => RecentMeetingModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class RecentMeetingModel extends RecentMeeting {
  const RecentMeetingModel({
    required String id,
    required String name,
    required String date,
    required int duration,
  }) : super(
    id: id,
    name: name,
    date: date,
    duration: duration,
  );

  factory RecentMeetingModel.fromJson(Map<String, dynamic> json) {
    return RecentMeetingModel(
      id: json['id'] as String,
      name: json['name'] as String,
      date: json['date'] as String,
      duration: json['duration'] as int,
    );
  }
}