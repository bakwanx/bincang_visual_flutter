import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/calendar_entities.dart';
import '../repositories/calendar_repository.dart';

class ScheduleMeeting implements UseCase<ScheduledMeeting, ScheduleMeetingParams> {
  final CalendarRepository repository;

  ScheduleMeeting(this.repository);

  @override
  Future<Either<Failure, ScheduledMeeting>> call(ScheduleMeetingParams params) async {
    return await repository.scheduleMeeting(
      title: params.title,
      description: params.description,
      startTime: params.startTime,
      endTime: params.endTime,
      attendees: params.attendees,
    );
  }
}

class ScheduleMeetingParams extends Equatable {
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> attendees;

  const ScheduleMeetingParams({
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    this.attendees = const [],
  });

  @override
  List<Object?> get props => [title, description, startTime, endTime, attendees];
}