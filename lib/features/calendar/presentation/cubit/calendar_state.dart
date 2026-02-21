part of 'calendar_cubit.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object?> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final List<ScheduledMeeting> meetings;

  const CalendarLoaded(this.meetings);

  @override
  List<Object?> get props => [meetings];
}

class MeetingScheduled extends CalendarState {
  final ScheduledMeeting meeting;

  const MeetingScheduled(this.meeting);

  @override
  List<Object?> get props => [meeting];
}

class CalendarError extends CalendarState {
  final String message;

  const CalendarError(this.message);

  @override
  List<Object?> get props => [message];
}