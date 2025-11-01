import 'package:bincang_visual_flutter/src/data/mapper/room_mapper.dart';
import 'package:bincang_visual_flutter/src/data/models/create_room_model.dart';
import 'package:bincang_visual_flutter/src/domain/entities/create_room_entity.dart';
import 'package:bincang_visual_flutter/utils/extension/null_helper_extenison.dart';

extension CreateRoomMapper on CreateRoomModel {
  CreateRoomEntity toEntity() {
    return CreateRoomEntity(data: data.toEntity(), message: message.orEmpty());
  }
}
