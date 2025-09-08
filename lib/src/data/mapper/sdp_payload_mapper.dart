import 'package:bincang_visual_flutter/src/data/mapper/user_mapper.dart';
import 'package:bincang_visual_flutter/src/data/models/sdp_payload_model.dart';
import 'package:bincang_visual_flutter/src/domain/entities/sdp_payload_entity.dart';

extension SdpPayloadMapper on SdpPayloadModel {
  SdpPayloadEntity toEntity(){
    return SdpPayloadEntity(sdp: sdp, typeSdp: typeSdp, userFrom: userFrom.toEntity(), userTarget: userTarget.toEntity());
  }
}


extension SdpPayloadToModelMapper on SdpPayloadEntity {
  SdpPayloadModel toModel(){
    return SdpPayloadModel(sdp: sdp, typeSdp: typeSdp, userFrom: userFrom.toModel(), userTarget: userTarget.toModel());
  }
}
