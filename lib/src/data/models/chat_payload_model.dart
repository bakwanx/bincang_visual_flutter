import 'package:bincang_visual_flutter/src/data/models/payload_model.dart';
import 'package:bincang_visual_flutter/src/data/models/user_model.dart';

class ChatPayloadModel extends PayloadModel {
  String roomId;
  UserModel userFrom;
  String message;

  ChatPayloadModel({
    required this.roomId,
    required this.userFrom,
    required this.message,
  });

  factory ChatPayloadModel.fromJson(Map<String, dynamic> json) => ChatPayloadModel(
    roomId: json["roomId"],
    userFrom: UserModel.fromJson(json["userFrom"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "roomId": roomId,
    "userFrom": userFrom.toJson(),
    "message": message,
  };
}
