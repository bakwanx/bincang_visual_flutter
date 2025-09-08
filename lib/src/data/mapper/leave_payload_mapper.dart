import 'package:bincang_visual_flutter/src/data/mapper/user_mapper.dart';
import 'package:bincang_visual_flutter/src/data/models/leave_payload_model.dart';
import 'package:bincang_visual_flutter/src/domain/entities/leave_payload_entity.dart';

extension LeavePayloadMapper on LeavePayloadModel {
  LeavePayloadEntity toEntity() {
    return LeavePayloadEntity(roomId: roomId, user: user.toEntity());
  }
}

extension LeavePayloadToModelMapper on LeavePayloadEntity {
  LeavePayloadModel toModel() {
    return LeavePayloadModel(roomId: roomId, user: user.toModel());
  }
}