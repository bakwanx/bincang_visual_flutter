import 'package:bincang_visual_flutter/src/data/models/user_model.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class RtcPeerConnectionModel {
  RTCPeerConnection peerConnection;
  UserModel userModel;

  RtcPeerConnectionModel({
    required this.peerConnection,
    required this.userModel,
  });
}
