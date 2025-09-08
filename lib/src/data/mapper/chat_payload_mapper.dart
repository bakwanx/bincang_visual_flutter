import 'package:bincang_visual_flutter/src/data/mapper/user_mapper.dart';
import 'package:bincang_visual_flutter/src/data/models/chat_payload_model.dart';
import 'package:bincang_visual_flutter/src/domain/entities/chat_payload_entity.dart';
import 'package:bincang_visual_flutter/utils/extension/null_helper_extenison.dart';

extension ChatPayloadMapper on ChatPayloadModel {
  ChatPayloadEntity toEntity() {
    return ChatPayloadEntity(
      roomId: roomId.orEmpty(),
      userFrom: userFrom.toEntity(),
      message: message.orEmpty(),
    );
  }
}

extension ChatPayloadToModelMapper on ChatPayloadEntity {
  ChatPayloadModel toModel() {
    return ChatPayloadModel(
      roomId: roomId,
      userFrom: userFrom.toModel(),
      message: message,
    );
  }
}