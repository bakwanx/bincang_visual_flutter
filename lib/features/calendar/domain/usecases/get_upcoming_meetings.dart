import 'package:either_dart/either.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/calendar_entities.dart';
import '../repositories/calendar_repository.dart';

class GetUpcomingMeetings implements UseCase<List<ScheduledMeeting>, NoParams> {
  final CalendarRepository repository;

  GetUpcomingMeetings(this.repository);

  @override
  Future<Either<Failure, List<ScheduledMeeting>>> call(NoParams params) async {
    return await repository.getUpcomingMeetings();
  }
}