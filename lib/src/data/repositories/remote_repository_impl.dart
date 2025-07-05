import 'dart:convert';

import 'package:bincang_visual_flutter/src/data/datasource/remote_datasource.dart';
import 'package:bincang_visual_flutter/src/data/models/coturn_configuration_model.dart';
import 'package:bincang_visual_flutter/src/data/models/create_room_model.dart';
import 'package:bincang_visual_flutter/src/data/models/user_model.dart';
import 'package:bincang_visual_flutter/src/domain/repositories/remote_repository.dart';
import 'package:bincang_visual_flutter/utils/encrypt/encrypt_util.dart';
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
      return Left(Exception('failed to create room $e'));
    }
  }

  @override
  Future<Either<Exception, CoturnConfigurationModel>> getConfiguration() async {
    try {
      final result = await remoteDataSource.getConfiguration();
      final decrypt = EncryptUtil.decryptData(result);
      final decode = jsonDecode(decrypt);
      return Right(CoturnConfigurationModel.fromJson(decode));
    }catch(e) {
      return Left(Exception('failed to create room $e'));
    }
  }

}