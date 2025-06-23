import 'package:bincang_visual_flutter/features/room/data/datasource/remote_datasource.dart';
import 'package:bincang_visual_flutter/features/room/data/models/create_room_model.dart';
import 'package:bincang_visual_flutter/features/room/data/models/user_model.dart';
import 'package:bincang_visual_flutter/features/room/domain/repositories/remote_repository.dart';
import 'package:either_dart/src/either.dart';

class RemoteRepositoryImpl implements RemoteRepository {
  RemoteDataSource remoteDataSource;
  RemoteRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Exception, UserModel>> registerUser(String username) async {
    try {
      final result = await remoteDataSource.registerUser(username);
      return Right(result);
    }catch(e) {
      return Left(Exception('failed to register'));
    }

  }

  @override
  Future<Either<Exception, CreateRoomModel>> createRoom() async {
    try {
      final result = await remoteDataSource.createRoom();
      return Right(result);
    }catch(e) {
      return Left(Exception('failed to create room'));
    }
  }

}