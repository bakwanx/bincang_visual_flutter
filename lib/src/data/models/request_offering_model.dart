import 'package:bincang_visual_flutter/src/data/models/payload_model.dart';
import 'package:bincang_visual_flutter/src/data/models/user_model.dart';

class RequestOfferingPayloadModel extends PayloadModel {
  String roomId;
  UserModel userRequest;

  RequestOfferingPayloadModel({required this.roomId, required this.userRequest});

  factory RequestOfferingPayloadModel.fromJson(Map<dynamic, dynamic> json) =>
      RequestOfferingPayloadModel(roomId: json['roomId'], userRequest: UserModel.fromJson(json['userRequest']));

  Map<String, dynamic> toJson() => {
    'userRequest': userRequest.toJson(),
    'roomId': roomId,
  };
}
