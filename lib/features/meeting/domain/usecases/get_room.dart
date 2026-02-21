import 'package:either_dart/either.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/meeting_entities.dart';
import '../repositories/meeting_repository.dart';
import 'join_room.dart';

class GetRoom implements UseCase<Room, JoinRoomParams> {
  final MeetingRepository repository;

  GetRoom(this.repository);

  @override
  Future<Either<Failure, Room>> call(JoinRoomParams params) async {
    return await repository.getRoom(params.roomId);
  }
}