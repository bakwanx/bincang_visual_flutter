class ApiPath {

  static AppMode appMode = AppMode.live;

  // wss
  // static String wsBaseUrl = 'wss://${_getBaseURL(appMode)}/ws';
  static String wsBaseUrl = _getBaseWSURL(appMode);
  // https
  static String baseUrl = 'https://${_getBaseURL(appMode)}';
  static String registerUser = '$baseUrl/register-user';
  static String createRoom = '$baseUrl/create-room';
  static String coturnConfiguration = '$baseUrl/coturn';
}

enum AppMode { live, local }

String _getBaseURL(final AppMode appMode) {
  switch (appMode) {
    case AppMode.live:
      return 'bincang-visual.cloud';
    default:
      return '192.168.31.149:3939';
  }
}

String _getBaseWSURL(final AppMode appMode) {
  switch (appMode) {
    case AppMode.live:
      return 'wss://${_getBaseURL(appMode)}/ws';
    default:
      return 'ws://${_getBaseURL(appMode)}/ws';
  }
}
