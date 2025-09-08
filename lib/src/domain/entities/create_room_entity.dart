import 'package:bincang_visual_flutter/src/domain/entities/room_entity.dart';

class CreateRoomEntity {
  RoomEntity data;
  String message;

  CreateRoomEntity({
    required this.data,
    required this.message,
  });
}
