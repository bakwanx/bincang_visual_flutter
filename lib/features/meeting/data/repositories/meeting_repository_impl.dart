import 'package:bincang_visual_flutter/features/meeting/domain/entities/meeting_entities.dart';
import 'package:bincang_visual_flutter/features/meeting/domain/repositories/meeting_repository.dart';
import 'package:either_dart/either.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/meeting_remote_datasource.dart';

class MeetingRepositoryImpl implements MeetingRepository {
  final MeetingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MeetingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Room>> createRoom({
    required String name,
    required int maxParticipants,
    required RoomSettings settings,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final room = await remoteDataSource.createRoom(
          name: name,
          maxParticipants: maxParticipants,
          settings: settings,
        );
        return Right(room);
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
  Future<Either<Failure, Room>> getRoom(String roomId) async {
    if (await networkInfo.isConnected) {
      try {
        final room = await remoteDataSource.getRoom(roomId);
        return Right(room);
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
  Future<Either<Failure, List<Participant>>> getParticipants(String roomId) async {
    if (await networkInfo.isConnected) {
      try {
        final participants = await remoteDataSource.getParticipants(roomId);
        return Right(participants);
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
  Future<Either<Failure, List<ChatMessage>>> getChatHistory(String roomId) async {
    if (await networkInfo.isConnected) {
      try {
        final messages = await remoteDataSource.getChatHistory(roomId);
        return Right(messages);
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
  Future<Either<Failure, Recording>> startRecording(String roomId) async {
    if (await networkInfo.isConnected) {
      try {
        final recording = await remoteDataSource.startRecording(roomId);
        return Right(recording);
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
  Future<Either<Failure, void>> stopRecording({
    required String roomId,
    required String recordingId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.stopRecording(roomId, recordingId);
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

  @override
  Future<Either<Failure, RoomConfig>> getIceServers() async {
    if (await networkInfo.isConnected) {
      try {
        final config = await remoteDataSource.getIceServers();
        return Right(config);
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