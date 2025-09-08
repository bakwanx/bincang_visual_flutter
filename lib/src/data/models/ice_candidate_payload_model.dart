import 'package:bincang_visual_flutter/src/data/models/payload_model.dart';
import 'package:bincang_visual_flutter/src/data/models/user_model.dart';

class IceCandidatePayloadModel extends PayloadModel {
  String candidate;
  int sdpMLineIndex;
  String sdpMid;
  UserModel userFrom;
  UserModel userTarget;

  IceCandidatePayloadModel({
    required this.candidate,
    required this.sdpMLineIndex,
    required this.sdpMid,
    required this.userFrom,
    required this.userTarget,
  });

  factory IceCandidatePayloadModel.fromJson(Map<dynamic, dynamic> json) =>
      IceCandidatePayloadModel(
        candidate: json['candidate'],
        sdpMLineIndex: json['sdpMLineIndex'],
        sdpMid: json['sdpMid'],
        userFrom: UserModel.fromJson(json['userFrom']),
        userTarget: UserModel.fromJson(json['userTarget']),
      );

  Map<String, dynamic> toJson() => {
    'candidate': candidate,
    'sdpMLineIndex': sdpMLineIndex,
    'sdpMid': sdpMid,
    'userFrom': userFrom.toJson(),
    'userTarget': userTarget.toJson(),
  };
}
