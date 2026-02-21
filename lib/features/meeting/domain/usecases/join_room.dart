import 'package:bincang_visual_flutter/core/usecase/usecase.dart';
import 'package:bincang_visual_flutter/features/meeting/domain/entities/meeting_entities.dart';
import 'package:bincang_visual_flutter/features/meeting/domain/repositories/meeting_repository.dart';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';

class JoinRoom implements UseCase<Room, JoinRoomParams> {
  final MeetingRepository repository;

  JoinRoom(this.repository);

  @override
  Future<Either<Failure, Room>> call(JoinRoomParams params) async {
    return await repository.getRoom(params.roomId);
  }
}

class JoinRoomParams extends Equatable {
  final String roomId;

  const JoinRoomParams({required this.roomId});

  @override
  List<Object?> get props => [roomId];
}