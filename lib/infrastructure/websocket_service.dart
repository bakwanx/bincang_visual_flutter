import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef MessageCallback = void Function(dynamic message);

class WebSocketService {

  late WebSocketChannel _channel;
  late String _userId;
  late String _roomId;
  bool _isConnected = false;
  late StreamController<dynamic> _controller;

  final _reconnectInterval = Duration(seconds: 5);
  Timer? _reconnectTimer;

  Stream<dynamic> get stream => _controller.stream;

  void connect({required String userId, required String roomId}) {
    _userId = userId;
    _roomId = roomId;

    final uri = Uri.parse(
      'wss://bincang-visual.cloud/ws',
    ).replace(queryParameters: {'username': _userId, 'roomId': _roomId});
    _controller = StreamController.broadcast();

    _channel = WebSocketChannel.connect(uri);
    _isConnected = true;
    _channel.stream.listen(
      (message) {
        _controller.add(message);
      },
      onDone: () {
        debugPrint('WebSocket closed');
        _isConnected = false;
        _controller.close();
        _scheduleReconnect();
      },
      onError: (error) {
        debugPrint('WebSocket error: $error');
        _controller.addError(error);
        _isConnected = false;
        _scheduleReconnect();
      },
    );
  }

  void _scheduleReconnect() {
    if (_reconnectTimer != null && _reconnectTimer!.isActive) return;
    _reconnectTimer = Timer(_reconnectInterval, () {
      debugPrint('Attempting to reconnect...');
      connect(userId: _userId, roomId: _roomId);
    });
  }

  void send(String message) {
    if (_isConnected) {
      _channel.sink.add(message);
    } else {
      debugPrint('WebSocket is not connected.');
    }
  }

  void close() {
    _channel.sink.close(3000);
    _isConnected = false;
    _reconnectTimer?.cancel();
  }
}