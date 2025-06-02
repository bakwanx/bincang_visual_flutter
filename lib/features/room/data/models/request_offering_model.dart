import 'package:bincang_visual_flutter/features/room/data/models/user_model.dart';

class RequestOfferingModel {
  String roomId;
  UserModel userRequest;

  RequestOfferingModel({required this.roomId, required this.userRequest});

  factory RequestOfferingModel.fromJson(Map<dynamic, dynamic> json) =>
      RequestOfferingModel(roomId: json['roomId'], userRequest: UserModel.fromJson(json['userRequest']));

  Map<String, dynamic> toJson() => {
    'userRequest': userRequest.toJson(),
    'roomId': roomId,
  };
}
