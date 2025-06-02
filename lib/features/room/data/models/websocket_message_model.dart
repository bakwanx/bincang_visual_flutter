import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';


class WebSocketMessageModel {
  String type;
  dynamic payload;

  WebSocketMessageModel({
    required this.type,
    required this.payload,
  });

  factory WebSocketMessageModel.fromJson(
    dynamic json) {
    final Map<String, dynamic> map = jsonDecode(json);
    return WebSocketMessageModel(
      type: map['type'],
      payload: map["payload"],
    );
  }

  String toJson() => jsonEncode({
    'type': type,
    'payload': payload,
  });
}


