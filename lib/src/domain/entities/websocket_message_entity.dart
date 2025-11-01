import 'package:bincang_visual_flutter/src/domain/entities/payload_entity.dart';

class WebSocketMessageEntity extends PayloadEntity{
  String type;
  dynamic payload;

  WebSocketMessageEntity({
    required this.type,
    required this.payload,
  });
}
