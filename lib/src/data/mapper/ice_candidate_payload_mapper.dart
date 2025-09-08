import 'package:bincang_visual_flutter/src/data/mapper/user_mapper.dart';
import 'package:bincang_visual_flutter/src/data/models/ice_candidate_payload_model.dart';
import 'package:bincang_visual_flutter/src/domain/entities/ice_candidate_payload_entity.dart';
import 'package:bincang_visual_flutter/utils/extension/null_helper_extenison.dart';

extension IceCandidatePayloadMapper on IceCandidatePayloadModel {
  IceCandidatePayloadEntity toEntity() {
    return IceCandidatePayloadEntity(
      candidate: candidate.orEmpty(),
      sdpMLineIndex: sdpMLineIndex.orEmpty(),
      sdpMid: sdpMid.orEmpty(),
      userFrom: userFrom.toEntity(),
      userTarget: userTarget.toEntity(),
    );
  }
}

extension IceCandidatePayloadToModelMapper on IceCandidatePayloadEntity {
  IceCandidatePayloadModel toModel() {
    return IceCandidatePayloadModel(
      candidate: candidate,
      sdpMLineIndex: sdpMLineIndex,
      sdpMid: sdpMid,
      userFrom: userFrom.toModel(),
      userTarget: userTarget.toModel(),
    );
  }
}
