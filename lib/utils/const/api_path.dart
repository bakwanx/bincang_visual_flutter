import 'package:bincang_visual_flutter/env/env.dart';

class ApiPath {
  static AppMode appMode = AppMode.prod;

  // wss
  static String wsBaseUrl = _getBaseWSURL(appMode);

  // https
  static String httpBaseUrl = _getHTTPBaseURL(appMode);
  static String registerUser = '/register-user';
  static String createRoom = '/create-room';
  static String coturnConfiguration = '/coturn';
  static String checkRoom = '/room';
}

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
