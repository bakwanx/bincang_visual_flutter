import 'package:either_dart/either.dart';

import '../../../../core/error/failures.dart';
import '../entities/calendar_entities.dart';

abstract class CalendarRepository {
  Future<Either<Failure, ScheduledMeeting>> scheduleMeeting({
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
    required List<String> attendees,
  });

  Future<Either<Failure, List<ScheduledMeeting>>> getUpcomingMeetings();

  Future<Either<Failure, void>> cancelMeeting(String eventId);
}
