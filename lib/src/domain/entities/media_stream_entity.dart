import 'package:bincang_visual_flutter/src/domain/entities/user_entity.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class MediaStreamEntity {
  MediaStream mediaStream;
  UserEntity userEntity;

  MediaStreamEntity({
    required this.mediaStream,
    required this.userEntity,
  });
}