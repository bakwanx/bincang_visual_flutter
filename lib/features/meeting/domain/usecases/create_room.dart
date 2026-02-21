import 'package:bincang_visual_flutter/core/usecase/usecase.dart';
import 'package:bincang_visual_flutter/features/meeting/domain/entities/meeting_entities.dart';
import 'package:bincang_visual_flutter/features/meeting/domain/repositories/meeting_repository.dart';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';

class CreateRoom implements UseCase<Room, CreateRoomParams> {
  final MeetingRepository repository;

  CreateRoom(this.repository);

  @override
  Future<Either<Failure, Room>> call(CreateRoomParams params) async {
    return await repository.createRoom(
      name: params.name,
      maxParticipants: params.maxParticipants,
      settings: params.settings,
    );
  }
}

class CreateRoomParams extends Equatable {
  final String name;
  final int maxParticipants;
  final RoomSettings settings;

  const CreateRoomParams({
    required this.name,
    this.maxParticipants = 100,
    this.settings = const RoomSettings(),
  });

  @override
  List<Object?> get props => [name, maxParticipants, settings];
}