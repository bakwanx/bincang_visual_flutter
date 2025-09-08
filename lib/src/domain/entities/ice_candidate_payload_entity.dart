import 'package:bincang_visual_flutter/src/domain/entities/payload_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/user_entity.dart';

class IceCandidatePayloadEntity extends PayloadEntity{
  String candidate;
  int sdpMLineIndex;
  String sdpMid;
  UserEntity userFrom;
  UserEntity userTarget;

  IceCandidatePayloadEntity({
    required this.candidate,
    required this.sdpMLineIndex,
    required this.sdpMid,
    required this.userFrom,
    required this.userTarget,
  });
}