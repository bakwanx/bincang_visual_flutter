import 'dart:convert';

import 'package:bincang_visual_flutter/src/data/models/coturn_configuration_model.dart';
import 'package:bincang_visual_flutter/src/data/models/create_room_model.dart';
import 'package:bincang_visual_flutter/src/data/models/user_model.dart';
import 'package:bincang_visual_flutter/utils/const/api_path.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class RemoteDataSource {
  Future<UserModel> registerUser(String username);

  Future<CreateRoomModel> createRoom();

  Future<String> getConfiguration();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;

  RemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> registerUser(String username) async {
    final result = await dio.post(
      ApiPath.registerUser,
      data: jsonEncode({"username": username}),
    );

    if (result.statusCode != 200) {
      throw DioException(requestOptions: result.requestOptions);
    }

    return UserModel.fromJson(result.data);
  }

  @override
  Future<CreateRoomModel> createRoom() async {
    final result = await dio.post(ApiPath.createRoom);

    if (result.statusCode != 200) {
      throw DioException(requestOptions: result.requestOptions);
    }

    return CreateRoomModel.fromJson(result.data);
  }

  @override
  Future<String> getConfiguration() async {
    final result = await dio.get(ApiPath.coturnConfiguration);

    if (result.statusCode != 200) {
      throw DioException(requestOptions: result.requestOptions);
    }

    final responseObj = CoturnConfigurationModelResponse.fromJson(result.data);


    return responseObj.data;
  }
}
