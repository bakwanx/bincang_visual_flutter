
import 'package:bincang_visual_flutter/src/data/models/user_model.dart';
import 'package:bincang_visual_flutter/src/domain/entities/user_entity.dart';
import 'package:bincang_visual_flutter/utils/extension/null_helper_extenison.dart';

extension UserMapper on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id.orEmpty(),
      username: username.orEmpty(),
    );
  }
}

extension UserToModelMapper on UserEntity {
  UserModel toModel() {
    return UserModel(
      id: id,
      username: username,
    );
  }
}
