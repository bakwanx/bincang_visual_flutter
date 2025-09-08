import 'package:bincang_visual_flutter/src/data/models/ping_payload_model.dart';
import 'package:bincang_visual_flutter/src/domain/entities/ping_payload_entity.dart';
import 'package:bincang_visual_flutter/utils/extension/null_helper_extenison.dart';

extension PingPayloadMapper on PingPongPayloadModel {
  PingPongPayloadEntity toEntity() {
    return PingPongPayloadEntity(
      message: message.orEmpty()
    );
  }
}

extension PingPayloadToModelMapper on PingPongPayloadEntity {
  PingPongPayloadModel toModel() {
    return PingPongPayloadModel(
        message: message,
    );
  }
}
