import '../../data/models/websocket_message_model.dart';

abstract class SignalingRepository {
  void sendMessage(WebSocketMessageModel message);
  Stream<WebSocketMessageModel> get onMessage;
  void dispose();
}