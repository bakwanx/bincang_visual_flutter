part of 'analytics_cubit.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final UserAnalytics analytics;

  const AnalyticsLoaded(this.analytics);


  int get totalMeetings => analytics.totalMeetings;
  double get totalDuration => analytics.totalDuration;
  double get averageDuration => analytics.averageDuration;
  int get thisMonthMeetings => analytics.thisMonthMeetings;
  List<double> get weeklyData => analytics.weeklyData;
  List<RecentMeeting> get recentMeetings => analytics.recentMeetings;

  @override
  List<Object?> get props => [analytics];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}