import 'dart:convert';

import 'package:bincang_visual_flutter/src/data/datasource/remote_datasource.dart';
import 'package:bincang_visual_flutter/src/data/mapper/coturn_configuration_mapper.dart';
import 'package:bincang_visual_flutter/src/data/mapper/create_room_mapper.dart';
import 'package:bincang_visual_flutter/src/data/mapper/user_mapper.dart';
import 'package:bincang_visual_flutter/src/data/models/coturn_configuration_model.dart';
import 'package:bincang_visual_flutter/src/domain/entities/coturn_configuration_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/create_room_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/user_entity.dart';
import 'package:bincang_visual_flutter/src/domain/repositories/remote_repository.dart';
import 'package:bincang_visual_flutter/utils/encrypt/encrypt_util.dart';
import 'package:either_dart/src/either.dart';

class RemoteRepositoryImpl implements RemoteRepository {
  RemoteDataSource remoteDataSource;
  RemoteRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Exception, UserEntity>> registerUser(String username) async {
    try {
      final result = await remoteDataSource.registerUser(username);
      return Right(result.toEntity());
    }catch(e) {
      return Left(Exception('failed to register'));
    }

  }

  @override
  Future<Either<Exception, CreateRoomEntity>> createRoom() async {
    try {
      final result = await remoteDataSource.createRoom();
      return Right(result.toEntity());
    }catch(e) {
      return Left(Exception('failed to create room $e'));
    }
  }

  @override
  Future<Either<Exception, CoturnConfigurationEntity>> getConfiguration() async {
    try {
      final result = await remoteDataSource.getConfiguration();
      final decrypt = EncryptUtil.decryptData(result);
      final decode = jsonDecode(decrypt);
      return Right(CoturnConfigurationModel.fromJson(decode).toEntity());
    }catch(e) {
      return Left(Exception('failed to get configuration $e'));
    }
  }

  @override
  Future<Either<Exception, void>> checkRoom(String roomId) async {
    try {
      final result = await remoteDataSource.checkRoom(roomId);
      return Right(result);
    }catch(e) {
      return Left(Exception('failed to check room $e'));
    }
  }

}