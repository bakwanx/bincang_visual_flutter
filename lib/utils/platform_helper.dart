import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web/web.dart' as web;

class PlatformHelper {
  static bool get isMobileWeb {
    if (!kIsWeb) return false;

    final userAgent = web.window.navigator.userAgent.toLowerCase();
    return userAgent.contains('mobile') ||
        userAgent.contains('android') ||
        userAgent.contains('iphone') ||
        userAgent.contains('ipad');
  }

  static bool get supportsScreenShare {
    return kIsWeb && !isMobileWeb;
  }
}