import 'package:bincang_visual_flutter/src/domain/entities/payload_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/user_entity.dart';

class LeavePayloadEntity extends PayloadEntity {
  String roomId;
  UserEntity user;

  LeavePayloadEntity({
    required this.roomId,
    required this.user,
  });
}