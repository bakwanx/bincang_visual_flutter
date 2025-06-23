import 'package:bincang_visual_flutter/features/room/data/models/user_model.dart';

class CreateRoomModel {
  RoomModel data;
  String message;

  CreateRoomModel({
    required this.data,
    required this.message,
  });

  factory CreateRoomModel.fromJson(Map<String, dynamic> json) => CreateRoomModel(
    data: RoomModel.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "message": message,
  };
}

class RoomModel {
  String roomId;
  String createdAt;
  UserModel? user;

  RoomModel({
    required this.roomId,
    required this.createdAt,
    required this.user,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
    roomId: json["roomId"],
    createdAt: json["createdAt"],
    user: UserModel.fromJson(json["users"]),
  );

  Map<String, dynamic> toJson() => {
    "roomId": roomId,
    "createdAt": createdAt,
    "users": user?.toJson(),
  };
}
