import 'package:bincang_visual_flutter/features/room/data/datasource/signaling_datasource.dart';
import 'package:bincang_visual_flutter/features/room/data/models/websocket_message_model.dart';
import 'package:bincang_visual_flutter/features/room/domain/repositories/signaling_repository.dart';

class SignalingRepositoryImpl implements SignalingRepository {
  final SignalingDataSource signalingDataSource;

  SignalingRepositoryImpl({required this.signalingDataSource});

  @override
  void dispose() {
    signalingDataSource.dispose();
  }

  @override
  Stream<WebSocketMessageModel> get onMessage => signalingDataSource.onMessage;

  @override
  void sendMessage(WebSocketMessageModel message) {
    signalingDataSource.sendMessage(message);
  }

}