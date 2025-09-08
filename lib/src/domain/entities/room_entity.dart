import 'package:bincang_visual_flutter/src/domain/entities/user_entity.dart';

class RoomEntity {
  String roomId;
  String createdAt;
  UserEntity? userEntity;

  RoomEntity({
    required this.roomId,
    required this.createdAt,
    required this.userEntity,
  });
}