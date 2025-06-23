import 'package:bincang_visual_flutter/features/room/data/models/create_room_model.dart';
import 'package:bincang_visual_flutter/features/room/data/models/user_model.dart';
import 'package:either_dart/either.dart';

abstract class RemoteRepository {
  Future<Either<Exception, UserModel>> registerUser(String username);
  Future<Either<Exception, CreateRoomModel>> createRoom();
}