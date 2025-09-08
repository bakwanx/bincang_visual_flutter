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
  WebSocketMessageEntity toEntity<T extends PayloadModel>() {
    final dataPayload = payload;
    dynamic dataMapper;
    if(T is PingPongPayloadModel){
      dataMapper = (dataPayload as PingPongPayloadModel).toEntity();
    }
    if(T is RequestOfferingPayloadModel){
      dataMapper = (dataPayload as RequestOfferingPayloadModel).toEntity();
    }
    if(T is SdpPayloadModel){
      dataMapper = (dataPayload as SdpPayloadModel).toEntity();
    }
    if(T is IceCandidatePayloadModel){
      dataMapper = (dataPayload as IceCandidatePayloadModel).toEntity();
    }
    if(T is ChatPayloadModel){
      dataMapper = (dataPayload as ChatPayloadModel).toEntity();
    }
    if(T is LeavePayloadModel){
      dataMapper = (dataPayload as LeavePayloadModel).toEntity();
    }

    return WebSocketMessageEntity(
      type: type,
      payload: dataMapper,
    );
  }
}

extension WebsocketMessageToModelMapper on WebSocketMessageEntity {
  WebSocketMessageModel toModel<T extends PayloadEntity>() {
    final dataPayload = payload;
    dynamic dataMapper;
    if(T is PingPongPayloadEntity){
      debugPrint("pesan pingpong");
      dataMapper = (dataPayload as PingPongPayloadEntity).toModel();
    }
    if(T is RequestOfferingPayloadEntity){
      dataMapper = (dataPayload as RequestOfferingPayloadEntity).toModel();
    }
    if(T is SdpPayloadEntity){
      dataMapper = (dataPayload as SdpPayloadEntity).toModel();
    }
    if(T is IceCandidatePayloadEntity){
      dataMapper = (dataPayload as IceCandidatePayloadEntity).toModel();
    }
    if(T is ChatPayloadEntity){
      dataMapper = (dataPayload as ChatPayloadEntity).toModel();
    }
    if(T is LeavePayloadModel){
      dataMapper = (dataPayload as LeavePayloadEntity).toModel();
    }
    return WebSocketMessageModel(
      type: type,
      payload: dataMapper,
    );
  }
}