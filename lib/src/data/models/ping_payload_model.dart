import 'package:bincang_visual_flutter/src/data/models/user_model.dart';

class PingPongPayloadModel {
  String message;

  PingPongPayloadModel({
    required this.message,
  });

  factory PingPongPayloadModel.fromJson(Map<String, dynamic> json) => PingPongPayloadModel(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
