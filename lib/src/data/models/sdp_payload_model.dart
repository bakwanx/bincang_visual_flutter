import 'package:bincang_visual_flutter/src/data/models/user_model.dart';

class SdpPayloadModel {
  String sdp;
  String typeSdp;
  UserModel userFrom;
  UserModel userTarget;

  SdpPayloadModel({
    required this.sdp,
    required this.typeSdp,
    required this.userFrom,
    required this.userTarget,
  });

  factory SdpPayloadModel.fromJson(Map<dynamic, dynamic> json) =>
      SdpPayloadModel(
        sdp: json['sdp'],
        typeSdp: json['typeSdp'],
        userFrom: UserModel.fromJson(json['userFrom']),
        userTarget: UserModel.fromJson(json['userTarget']),
      );

  Map<String, dynamic> toJson() => {
    'sdp': sdp,
    'typeSdp': typeSdp,
    'userFrom': userFrom.toJson(),
    'userTarget': userTarget.toJson(),
  };
}
