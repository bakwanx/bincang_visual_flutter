import 'package:bincang_visual_flutter/src/data/models/user_model.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class MediaStreamModel {
  MediaStream mediaStream;
  UserModel userModel;

  MediaStreamModel({
    required this.mediaStream,
    required this.userModel,
  });
}