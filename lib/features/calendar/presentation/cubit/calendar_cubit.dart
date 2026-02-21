import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/calendar_entities.dart';
import '../../domain/usecases/cancel_meeting.dart';
import '../../domain/usecases/get_upcoming_meetings.dart';
import '../../domain/usecases/schedule_meeting.dart';
part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final ScheduleMeeting scheduleMeeting;
  final GetUpcomingMeetings getUpcomingMeetings;
  final CancelMeeting cancelMeeting;

  CalendarCubit({
    required this.scheduleMeeting,
    required this.getUpcomingMeetings,
    required this.cancelMeeting,
  }) : super(CalendarInitial());

  Future<void> loadUpcomingMeetings() async {
    emit(CalendarLoading());

    final result = await getUpcomingMeetings(NoParams());

    result.fold(
          (failure) => emit(CalendarError(failure.message)),
          (meetings) => emit(CalendarLoaded(meetings)),
    );
  }

  Future<void> createScheduledMeeting({
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
    List<String> attendees = const [],
  }) async {
    emit(CalendarLoading());

    final result = await scheduleMeeting(ScheduleMeetingParams(
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      attendees: attendees,
    ));

    result.fold(
          (failure) => emit(CalendarError(failure.message)),
          (meeting) {
        loadUpcomingMeetings();
        emit(MeetingScheduled(meeting));
      },
    );
  }

  Future<void> cancelScheduledMeeting(String eventId) async {
    final result = await cancelMeeting(CancelMeetingParams(eventId: eventId));

    result.fold(
          (failure) => emit(CalendarError(failure.message)),
          (_) => loadUpcomingMeetings(),
    );
  }
}