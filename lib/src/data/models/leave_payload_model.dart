import 'package:bincang_visual_flutter/src/data/models/user_model.dart';

class LeavePayloadModel {
  String roomId;
  UserModel user;

  LeavePayloadModel({required this.roomId, required this.user});

  factory LeavePayloadModel.fromJson(Map<dynamic, dynamic> json) =>
      LeavePayloadModel(roomId: json['roomId'], user: UserModel.fromJson(json['user']));

  Map<String, dynamic> toJson() => {'roomId': roomId, 'user': user.toJson()};
}
