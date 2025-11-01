import 'package:bincang_visual_flutter/src/data/mapper/chat_payload_mapper.dart';
import 'package:bincang_visual_flutter/src/data/mapper/ice_candidate_payload_mapper.dart';
import 'package:bincang_visual_flutter/src/data/mapper/leave_payload_mapper.dart';
import 'package:bincang_visual_flutter/src/data/mapper/ping_payload_mapper.dart';
import 'package:bincang_visual_flutter/src/data/mapper/request_offering_mapper.dart';
import 'package:bincang_visual_flutter/src/data/mapper/sdp_payload_mapper.dart';
import 'package:bincang_visual_flutter/src/data/models/chat_payload_model.dart';
import 'package:bincang_visual_flutter/src/data/models/ice_candidate_payload_model.dart';
import 'package:bincang_visual_flutter/src/data/models/leave_payload_model.dart';
import 'package:bincang_visual_flutter/src/data/models/payload_model.dart';
import 'package:bincang_visual_flutter/src/data/models/ping_payload_model.dart';
import 'package:bincang_visual_flutter/src/data/models/request_offering_model.dart';
import 'package:bincang_visual_flutter/src/data/models/sdp_payload_model.dart';
import 'package:bincang_visual_flutter/src/data/models/websocket_message_model.dart';
import 'package:bincang_visual_flutter/src/domain/entities/chat_payload_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/ice_candidate_payload_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/leave_payload_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/payload_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/ping_payload_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/request_offering_payload_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/sdp_payload_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/websocket_message_entity.dart';
import 'package:flutter/cupertino.dart';

extension WebsocketMessageMapper on WebSocketMessageModel {
  WebSocketMessageEntity toEntity() {
    final dataPayload = payload;
    dynamic dataMapper;
    if(dataPayload is PingPongPayloadModel){
      dataMapper = dataPayload.toEntity();
    }
    if(dataPayload is RequestOfferingPayloadModel){
      dataMapper = dataPayload.toEntity();
    }
    if(dataPayload is SdpPayloadModel){
      dataMapper = dataPayload.toEntity();
    }
    if(dataPayload is IceCandidatePayloadModel){
      dataMapper = dataPayload.toEntity();
    }
    if(dataPayload is ChatPayloadModel){
      dataMapper = dataPayload.toEntity();
    }
    if(dataPayload is LeavePayloadModel){
      dataMapper = dataPayload.toEntity();
    }

    return WebSocketMessageEntity(
      type: type,
      payload: dataMapper,
    );
  }
}

extension WebsocketMessageToModelMapper on WebSocketMessageEntity {
  WebSocketMessageModel toModel() {
    final dataPayload = payload;
    dynamic dataMapper;

    if (dataPayload is PingPongPayloadEntity) {
      dataMapper = dataPayload.toModel();
    } else if (dataPayload is RequestOfferingPayloadEntity) {
      dataMapper = dataPayload.toModel();
    } else if (dataPayload is SdpPayloadEntity) {
      dataMapper = dataPayload.toModel();
    } else if (dataPayload is IceCandidatePayloadEntity) {
      dataMapper = dataPayload.toModel();
    } else if (dataPayload is ChatPayloadEntity) {
      dataMapper = dataPayload.toModel();
    } else if (dataPayload is LeavePayloadEntity) {
      dataMapper = dataPayload.toModel();
    } else {
      debugPrint('Unknown payload type: ${dataPayload.runtimeType}');
    }

    return WebSocketMessageModel(
      type: type,
      payload: dataMapper,
    );
  }
}