import 'package:bincang_visual_flutter/env/env.dart';
import 'package:flutter/foundation.dart';

enum AppMode { prod, dev }

String _getBaseURL(final AppMode appMode) {
  switch (appMode) {
    case AppMode.prod:
      return Env.prodUrl;
    default:
      return Env.devUrl;
  }
}

String _getHTTPBaseURL(final AppMode appMode) {
  switch (appMode) {
    case AppMode.prod:
      return 'https://${_getBaseURL(appMode)}';
    default:
      return 'http://${_getBaseURL(appMode)}';
  }
}

String _getBaseWSURL(final AppMode appMode) {
  switch (appMode) {
    case AppMode.prod:
      return 'wss://${_getBaseURL(appMode)}/ws';
    default:
      return 'ws://${_getBaseURL(appMode)}/ws';
  }
}

class ApiConstants {
  static AppMode appMode = kDebugMode ? AppMode.dev : AppMode.prod;

  static String baseUrl = _getHTTPBaseURL(appMode);
  static String wsUrl = _getBaseWSURL(appMode);

  // Endpoints
  static const String rooms = '/api/rooms';
  static String room(String id) => '/api/rooms/$id';
  static String participants(String roomId) => '/api/rooms/$roomId/participants';
  static String chatHistory(String roomId) => '/api/rooms/$roomId/chat';
  static const String iceServers = '/api/ice-servers';
  static const String startRecording = '/api/recordings/start';
  static const String stopRecording = '/api/recordings/stop';
  static const String uploadChunk = '/api/recordings/upload-chunk';

  // WebSocket
  static String wsRoom(String roomId) => '/room/$roomId';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}