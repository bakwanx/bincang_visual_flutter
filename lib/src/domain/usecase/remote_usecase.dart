import 'package:bincang_visual_flutter/src/domain/entities/coturn_configuration_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/create_room_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/user_entity.dart';
import 'package:bincang_visual_flutter/src/domain/repositories/remote_repository.dart';
import 'package:either_dart/either.dart';

class RemoteUseCase {
  final RemoteRepository repository;

  RemoteUseCase({required this.repository});

  Future<Either<Exception, UserEntity>> registerUser(String username) async {
    return repository.registerUser(username);
  }

  Future<Either<Exception, CreateRoomEntity>> createRoom() async {
    return repository.createRoom();
  }

  Future<Either<Exception, CoturnConfigurationEntity>> getConfiguration() async {
    return repository.getConfiguration();
  }

  Future<Either<Exception, void>> checkRoom(String roomId) async {
    return repository.checkRoom(roomId);
  }
}
