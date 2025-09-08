import 'package:bincang_visual_flutter/src/domain/entities/coturn_configuration_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/create_room_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/user_entity.dart';
import 'package:either_dart/either.dart';

abstract class RemoteRepository {
  Future<Either<Exception, UserEntity>> registerUser(String username);
  Future<Either<Exception, CreateRoomEntity>> createRoom();
  Future<Either<Exception, CoturnConfigurationEntity>> getConfiguration();
  Future<Either<Exception, void>> checkRoom(String roomId);
}