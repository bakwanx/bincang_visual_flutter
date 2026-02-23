import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html show window;

class PlatformHelper {
  static bool get isMobileWeb {
    if (!kIsWeb) return false;

    final userAgent = html.window.navigator.userAgent.toLowerCase();
    return userAgent.contains('mobile') ||
        userAgent.contains('android') ||
        userAgent.contains('iphone') ||
        userAgent.contains('ipad');
  }

  static bool get supportsScreenShare {
    return kIsWeb && !isMobileWeb;
  }
}