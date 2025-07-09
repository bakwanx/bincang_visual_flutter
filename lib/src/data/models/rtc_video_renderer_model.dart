import 'package:bincang_visual_flutter/src/data/models/user_model.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class RtcVideoRendererModel {
  RTCVideoRenderer rtcVideoRenderer;
  UserModel userModel;

  RtcVideoRendererModel({
    required this.rtcVideoRenderer,
    required this.userModel,
  });
}
