import 'package:bincang_visual_flutter/src/data/models/user_model.dart';

class OfferPayloadModel {
  UserModel userFrom;
  UserModel userTarget;

  OfferPayloadModel({required this.userFrom, required this.userTarget});

  factory OfferPayloadModel.fromJson(Map<dynamic, dynamic> json) =>
      OfferPayloadModel(
        userFrom: UserModel.fromJson(json['userFrom']),
        userTarget: UserModel.fromJson(json['userTarget']),
      );

  Map<String, dynamic> toJson() => {
    'userFrom': userFrom.toJson(),
    'userTarget': userTarget.toJson(),
  };
}
