import 'package:bincang_visual_flutter/src/domain/entities/payload_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/user_entity.dart';

class SdpPayloadEntity extends PayloadEntity {
  String sdp;
  String typeSdp;
  UserEntity userFrom;
  UserEntity userTarget;

  SdpPayloadEntity({
    required this.sdp,
    required this.typeSdp,
    required this.userFrom,
    required this.userTarget,
  });
}