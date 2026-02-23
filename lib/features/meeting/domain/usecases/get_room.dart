import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/meeting_entities.dart';
import '../repositories/meeting_repository.dart';

class GetRoom implements UseCase<Room, GetRoomParams> {
  final MeetingRepository repository;

  GetRoom(this.repository);

  @override
  Future<Either<Failure, Room>> call(GetRoomParams params) async {
    return await repository.getRoom(params.roomId);
  }
}

class GetRoomParams extends Equatable {
  final String roomId;

  const GetRoomParams({required this.roomId});

  @override
  List<Object?> get props => [roomId];
}