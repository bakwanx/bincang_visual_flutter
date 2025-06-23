import 'package:bincang_visual_flutter/features/room/domain/repositories/remote_repository.dart';
import 'package:either_dart/either.dart';

import '../../data/models/user_model.dart';

class RemoteUseCase {
  final RemoteRepository repository;

  RemoteUseCase({required this.repository});

  Future<Either<Exception, UserModel>> registerUser(String username) async {
    return repository.registerUser(username);
  }
}
