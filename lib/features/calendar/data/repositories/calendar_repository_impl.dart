
import 'package:either_dart/either.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/calendar_entities.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../datasources/calendar_remote_datasource.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CalendarRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ScheduledMeeting>> scheduleMeeting({
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
    required List<String> attendees,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final meeting = await remoteDataSource.scheduleMeeting(
          title: title,
          description: description,
          startTime: startTime,
          endTime: endTime,
          attendees: attendees,
        );
        return Right(meeting);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ScheduledMeeting>>> getUpcomingMeetings() async {
    if (await networkInfo.isConnected) {
      try {
        final meetings = await remoteDataSource.getUpcomingMeetings();
        return Right(meetings);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> cancelMeeting(String eventId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.cancelMeeting(eventId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}