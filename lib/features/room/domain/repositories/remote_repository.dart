import 'package:bincang_visual_flutter/features/room/data/models/user_model.dart';
import 'package:either_dart/either.dart';

abstract class RemoteRepository {
  Future<Either<Exception, UserModel>> registerUser(String username);
}