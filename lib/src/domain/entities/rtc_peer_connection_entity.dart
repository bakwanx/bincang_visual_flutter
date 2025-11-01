import 'package:bincang_visual_flutter/src/data/models/user_model.dart';
import 'package:bincang_visual_flutter/src/domain/entities/user_entity.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class RtcPeerConnectionEntity {
  RTCPeerConnection peerConnection;
  UserEntity userEntity;

  RtcPeerConnectionEntity({
    required this.peerConnection,
    required this.userEntity,
  });
}