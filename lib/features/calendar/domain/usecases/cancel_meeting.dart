import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/calendar_repository.dart';

class CancelMeeting implements UseCase<void, CancelMeetingParams> {
  final CalendarRepository repository;

  CancelMeeting(this.repository);

  @override
  Future<Either<Failure, void>> call(CancelMeetingParams params) async {
    return await repository.cancelMeeting(params.eventId);
  }
}

class CancelMeetingParams extends Equatable {
  final String eventId;

  const CancelMeetingParams({required this.eventId});

  @override
  List<Object?> get props => [eventId];
}