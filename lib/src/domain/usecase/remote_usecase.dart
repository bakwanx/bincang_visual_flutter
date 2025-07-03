import 'package:bincang_visual_flutter/src/data/models/coturn_configuration_model.dart';
import 'package:bincang_visual_flutter/src/data/models/create_room_model.dart';
import 'package:bincang_visual_flutter/src/domain/repositories/remote_repository.dart';
import 'package:either_dart/either.dart';

import '../../data/models/user_model.dart';

class RemoteUseCase {
  final RemoteRepository repository;

  RemoteUseCase({required this.repository});

  Future<Either<Exception, UserModel>> registerUser(String username) async {
    return repository.registerUser(username);
  }

  Future<Either<Exception, CreateRoomModel>> createRoom() async {
    return repository.createRoom();
  }

  Future<Either<Exception, CoturnConfigurationModel>> getConfiguration() async {
    return repository.getConfiguration();
  }
}
