import 'package:bincang_visual_flutter/src/data/mapper/websocket_message_mapper.dart';
import 'package:bincang_visual_flutter/src/data/models/websocket_message_model.dart';
import 'package:bincang_visual_flutter/src/domain/entities/payload_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/websocket_message_entity.dart';
import 'package:bincang_visual_flutter/src/domain/repositories/signaling_repository.dart';

class SignalingUseCase{
  final SignalingRepository repository;

  SignalingUseCase({required this.repository});

  void sendMessage<T extends PayloadEntity>(WebSocketMessageEntity message) {
    return repository.sendMessage(message.toModel<T>());
  }

  Stream<WebSocketMessageModel> get onMessage => repository.onMessage;

  void dispose() => repository.dispose();
}