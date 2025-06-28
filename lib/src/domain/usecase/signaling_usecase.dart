import 'package:bincang_visual_flutter/src/data/models/websocket_message_model.dart';
import 'package:bincang_visual_flutter/src/domain/repositories/signaling_repository.dart';

class SignalingUseCase{
  final SignalingRepository repository;

  SignalingUseCase({required this.repository});

  void sendMessage(WebSocketMessageModel message) => repository.sendMessage(message);

  Stream<WebSocketMessageModel> get onMessage => repository.onMessage;

  void dispose() => repository.dispose();
}