import 'package:bincang_visual_flutter/src/data/models/coturn_configuration_model.dart';
import 'package:bincang_visual_flutter/src/data/models/create_room_model.dart';
import 'package:bincang_visual_flutter/src/data/models/user_model.dart';
import 'package:either_dart/either.dart';

abstract class RemoteRepository {
  Future<Either<Exception, UserModel>> registerUser(String username);
  Future<Either<Exception, CreateRoomModel>> createRoom();
  Future<Either<Exception, CoturnConfigurationModel>> getConfiguration();
}