class ApiPath {

  static AppMode appMode = AppMode.local;

  // wss
  static String wsBaseUrl = 'ws://${_getBaseURL(appMode)}/ws';
  // https
  static String baseUrl = 'http://${_getBaseURL(appMode)}';
  static String registerUser = '$baseUrl/register-user';
  static String createRoom = '$baseUrl/create-room';
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
