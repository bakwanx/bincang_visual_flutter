import 'package:bincang_visual_flutter/src/domain/entities/payload_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/user_entity.dart';

class ChatPayloadEntity extends PayloadEntity{
  String roomId;
  UserEntity userFrom;
  String message;

  ChatPayloadEntity({
    required this.roomId,
    required this.userFrom,
    required this.message,
  });
}