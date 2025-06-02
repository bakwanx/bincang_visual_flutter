import 'dart:convert';

import 'package:bincang_visual_flutter/features/room/data/models/websocket_message_model.dart';
import 'package:bincang_visual_flutter/infrastructure/websocket_service.dart';

abstract class SignalingDataSource{
  void sendMessage(WebSocketMessageModel message);
  Stream<WebSocketMessageModel> get onMessage;
  void dispose();
}

class SignalingDataSourceImpl implements SignalingDataSource {
  final WebSocketService webSocketService;
  SignalingDataSourceImpl({required this.webSocketService});

  @override
  void dispose() {
    webSocketService.close();
  }

  @override
  Stream<WebSocketMessageModel> get onMessage => webSocketService.stream.map((convert) => WebSocketMessageModel.fromJson(convert));

  @override
  void sendMessage(WebSocketMessageModel message) {
    webSocketService.send(message.toJson());
  }

}