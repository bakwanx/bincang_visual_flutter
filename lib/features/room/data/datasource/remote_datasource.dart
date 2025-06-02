import 'package:bincang_visual_flutter/features/room/data/models/user_model.dart';
import 'package:bincang_visual_flutter/utils/const/api_path.dart';
import 'package:dio/dio.dart';

abstract class RemoteDataSource {
  Future<UserModel> registerUser(String username);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;
  RemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> registerUser(String username) async {
    final result = await dio.post(
      ApiPath.registerUser,
      data: {
        "username": username,
      },
    );

    if(result.statusCode != 200){
      throw DioException(requestOptions: result.requestOptions);
    }
    return UserModel.fromJson(result.data);
  }

}