import 'dart:async';
import 'dart:convert';
import 'package:bincang_visual_flutter/features/meeting/domain/entities/meeting_entities.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../../../../core/network/api_constants.dart';
import '../utils/log/print_debug_log.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;
  bool _isIntentionalDisconnect = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _heartbeatInterval = Duration(seconds: 10);

  String? _roomId;
  String? _userId;
  String? _displayName;

  final _messageController = StreamController<SignalMessage>.broadcast();
  final _connectionStateController =
      StreamController<WebSocketConnectionState>.broadcast();

  Stream<SignalMessage> get messages => _messageController.stream;

  Stream<WebSocketConnectionState> get connectionState =>
      _connectionStateController.stream;

  bool _isDisposed = false;
  bool _isConnecting = false;

  Future<void> connect({
    required String roomId,
    required String userId,
    required String displayName,
  }) async {
    _isIntentionalDisconnect = false;
    if (_isDisposed) throw Exception('Service is disposed');
    if (_isConnecting) {
      printDebugLog(tag: 'WebSocket', message: 'Already connecting');
      return;
    }

    _roomId = roomId;
    _userId = userId;
    _displayName = displayName;
    _isConnecting = true;

    try {
      final wsUrl = ApiConstants.wsUrl;
      final uri = Uri.parse(
        '$wsUrl${ApiConstants.wsRoom(roomId)}?userId=$userId&displayName=${Uri.encodeComponent(displayName)}',
      );

      printDebugLog(tag: 'WebSocket ', message: 'Connecting to: $uri');
      _connectionStateController.add(WebSocketConnectionState.connecting);

      // if (_channel != null) {
      //   printDebugLog('[WebSocket] Already connected');
      //   return;
      // }
      _channel = WebSocketChannel.connect(uri);

      await _channel!.ready;

      printDebugLog(tag: 'WebSocket', message: 'Connected successfully');
      _isConnecting = false;
      _reconnectAttempts = 0;
      _connectionStateController.add(WebSocketConnectionState.connected);

      _startHeartbeat();

      _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnection,
        cancelOnError: false,
      );
    } catch (e) {
      printDebugLog(tag: 'WebSocket', message: 'Connection error: $e');
      _isConnecting = false;
      _connectionStateController.add(WebSocketConnectionState.error);
      _handleReconnection();
    }
  }

  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message as String) as Map<String, dynamic>;

      if (data['type'] == 'pong') {
        printDebugLog(tag: 'WebSocket', message: 'Heartbeat received');
        return;
      }

      final signalMessage = _parseSignalMessage(data);
      _messageController.add(signalMessage);
    } catch (e) {
      printDebugLog(tag: 'WebSocket', message: 'Failed to parse message: $e');
    }
  }

  void _handleError(error) {
    printDebugLog(tag: 'WebSocket', message: 'Error: $error');
    _connectionStateController.add(WebSocketConnectionState.error);
    _stopHeartbeat();
  }

  void _handleDisconnection() {
    printDebugLog(tag: 'WebSocket', message: 'Connection closed');
    _connectionStateController.add(WebSocketConnectionState.disconnected);
    _stopHeartbeat();
    if (!_isIntentionalDisconnect) {
      _handleReconnection();
    } else {
      printDebugLog(
        tag: 'WebSocket',
        message: 'Intentional disconnect - not reconnecting',
      );
    }
  }

  void _handleReconnection() {
    if (_isDisposed || _roomId == null) return;
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      printDebugLog(
        tag: 'WebSocket',
        message: 'Max reconnection attempts reached',
      );
      _connectionStateController.add(WebSocketConnectionState.failed);
      return;
    }

    _reconnectAttempts++;
    final delay = Duration(seconds: 2 * _reconnectAttempts);

    printDebugLog(
      tag: 'WebSocket',
      message:
          'Reconnecting in ${delay.inSeconds}s (attempt $_reconnectAttempts)',
    );
    _connectionStateController.add(WebSocketConnectionState.reconnecting);

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      if (!_isDisposed && _roomId != null) {
        connect(
          roomId: _roomId!,
          userId: _userId!,
          displayName: _displayName ?? '',
        );
      }
    });
  }

  void _startHeartbeat() {
    _stopHeartbeat();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (timer) {
      if (_channel != null && !_isDisposed) {
        send(
          SignalMessage(
            type: SignalType.ping,
            from: _userId ?? '',
            roomId: _roomId ?? '',
            timestamp: DateTime.now(),
          ),
        );
      }
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  void send(SignalMessage message) {
    if (_channel == null || _isDisposed) {
      printDebugLog(tag: 'WebSocket', message: 'Cannot send message: not connected');
      return;
    }

    try {
      final data = _serializeSignalMessage(message);
      _channel!.sink.add(jsonEncode(data));
    } catch (e) {
      printDebugLog(tag: 'WebSocket', message: 'Failed to send message: $e');
    }
  }

  SignalMessage _parseSignalMessage(Map<String, dynamic> data) {
    return SignalMessage(
      type: _parseSignalType(data['type'] as String),
      from: data['from'] as String,
      to: data['to'] as String?,
      roomId: data['roomId'] as String,
      data: data['data'] as Map<String, dynamic>?,
      timestamp: DateTime.parse(data['timestamp'] as String),
    );
  }

  Map<String, dynamic> _serializeSignalMessage(SignalMessage message) {
    return {
      'type': _signalTypeToString(message.type),
      'from': message.from,
      if (message.to != null) 'to': message.to,
      'roomId': message.roomId,
      if (message.data != null) 'data': message.data,
      'timestamp': message.timestamp.toUtc().toIso8601String(),
    };
  }

  SignalType _parseSignalType(String type) {
    switch (type) {
      case 'ping':
        return SignalType.ping;
      case 'pong':
        return SignalType.pong;
      case 'offer':
        return SignalType.offer;
      case 'answer':
        return SignalType.answer;
      case 'ice':
        return SignalType.ice;
      case 'peer-joined':
        return SignalType.peerJoined;
      case 'peer-left':
        return SignalType.peerLeft;
      case 'chat':
        return SignalType.chat;
      case 'media-state':
        return SignalType.mediaState;
      case 'screen-share':
        return SignalType.screenShare;
      case 'leave':
        return SignalType.leave;
      default:
        return SignalType.join;
    }
  }

  String _signalTypeToString(SignalType type) {
    switch (type) {
      case SignalType.ping:
        return 'ping';
      case SignalType.pong:
        return 'pong';
      case SignalType.offer:
        return 'offer';
      case SignalType.answer:
        return 'answer';
      case SignalType.ice:
        return 'ice';
      case SignalType.peerJoined:
        return 'peer-joined';
      case SignalType.peerLeft:
        return 'peer-left';
      case SignalType.chat:
        return 'chat';
      case SignalType.mediaState:
        return 'media-state';
      case SignalType.screenShare:
        return 'screen-share';
      case SignalType.screenShareError:
        return 'screen-share-error';
      case SignalType.leave:
        return 'leave';
      case SignalType.join:
        return 'join';
    }
  }

  void disconnect() {
    _isIntentionalDisconnect = true;
    _stopHeartbeat();
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    if (_channel != null) {
      _channel!.sink.close(3000);
      _channel = null;
    }

    _connectionStateController.add(WebSocketConnectionState.disconnected);
  }

  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;

    disconnect();

    await _messageController.close();
    await _connectionStateController.close();
  }

  bool get isConnected => _channel != null && !_isDisposed;

  String? get currentRoomId => _roomId;

  String? get currentUserId => _userId;
}

enum WebSocketConnectionState {
  connecting,
  connected,
  reconnecting,
  disconnected,
  error,
  failed,
}
