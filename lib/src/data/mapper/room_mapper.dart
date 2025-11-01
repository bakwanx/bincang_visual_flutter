import 'package:bincang_visual_flutter/src/data/mapper/user_mapper.dart';
import 'package:bincang_visual_flutter/src/data/models/create_room_model.dart';
import 'package:bincang_visual_flutter/src/domain/entities/room_entity.dart';
import 'package:bincang_visual_flutter/utils/extension/null_helper_extenison.dart';

extension RoomMapper on RoomModel {
  RoomEntity toEntity() {
    return RoomEntity(
      roomId: roomId.orEmpty(),
      createdAt: createdAt.orEmpty(),
      userEntity: user?.toEntity(),
    );
  }
}
