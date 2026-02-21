import 'package:bincang_visual_flutter/core/usecase/usecase.dart';
import 'package:bincang_visual_flutter/features/meeting/domain/entities/meeting_entities.dart';
import 'package:bincang_visual_flutter/features/meeting/domain/repositories/meeting_repository.dart';
import 'package:either_dart/either.dart';

import '../../../../core/error/failures.dart';

class GetIceServers implements UseCase<RoomConfig, NoParams> {
  final MeetingRepository repository;

  GetIceServers(this.repository);

  @override
  Future<Either<Failure, RoomConfig>> call(NoParams params) async {
    return await repository.getIceServers();
  }
}