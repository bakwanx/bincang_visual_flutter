import 'dart:async';
import 'dart:convert';
import 'package:bincang_visual_flutter/features/meeting/domain/entities/meeting_entities.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../../../../core/network/api_constants.dart';

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
  final _connectionStateController = StreamController<WebSocketConnectionState>.broadcast();


  Stream<SignalMessage> get messages => _messageController.stream;
  Stream<WebSocketConnectionState> get connectionState => _connectionStateController.stream;

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
      print('[WebSocket] Already connecting');
      return;
    }


    _roomId = roomId;
    _userId = userId;
    _displayName = displayName;
    _isConnecting = true;

    try {
      final wsUrl = ApiConstants.wsUrl;
      final uri = Uri.parse('$wsUrl${ApiConstants.wsRoom(roomId)}?userId=$userId&displayName=${Uri.encodeComponent(displayName)}');

      print('[WebSocket] Connecting to: $uri');
      _connectionStateController.add(WebSocketConnectionState.connecting);

      // if (_channel != null) {
      //   print('[WebSocket] Already connected');
      //   return;
      // }
      _channel = WebSocketChannel.connect(uri);


      await _channel!.ready;

      print('[WebSocket] Connected successfully');
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
      print('[WebSocket] Connection error: $e');
      _isConnecting = false;
      _connectionStateController.add(WebSocketConnectionState.error);
      _handleReconnection();
    }
  }


  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message as String) as Map<String, dynamic>;


      if (data['type'] == 'pong') {
        print('[WebSocket] Heartbeat received');
        return;
      }

      final signalMessage = _parseSignalMessage(data);
      _messageController.add(signalMessage);
    } catch (e) {
      print('[WebSocket] Failed to parse message: $e');
    }
  }


  void _handleError(error) {
    print('[WebSocket] Error: $error');
    _connectionStateController.add(WebSocketConnectionState.error);
    _stopHeartbeat();
  }


  void _handleDisconnection() {
    print('[WebSocket] Connection closed');
    _connectionStateController.add(WebSocketConnectionState.disconnected);
    _stopHeartbeat();
    if (!_isIntentionalDisconnect) {
      _handleReconnection();
    } else {
      print('[WebSocket] Intentional disconnect - not reconnecting');
    }
  }


  void _handleReconnection() {
    if (_isDisposed || _roomId == null) return;
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      print('[WebSocket] Max reconnection attempts reached');
      _connectionStateController.add(WebSocketConnectionState.failed);
      return;
    }

    _reconnectAttempts++;
    final delay = Duration(seconds: 2 * _reconnectAttempts);

    print('[WebSocket] Reconnecting in ${delay.inSeconds}s (attempt $_reconnectAttempts)');
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
        send(SignalMessage(
          type: SignalType.ping,
          from: _userId ?? '',
          roomId: _roomId ?? '',
          timestamp: DateTime.now(),
        ));
      }
    });
  }


  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }


  void send(SignalMessage message) {
    if (_channel == null || _isDisposed) {
      print('[WebSocket] Cannot send message: not connected');
      return;
    }

    try {
      final data = _serializeSignalMessage(message);
      _channel!.sink.add(jsonEncode(data));
    } catch (e) {
      print('[WebSocket] Failed to send message: $e');
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