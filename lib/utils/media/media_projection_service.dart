import 'package:flutter/services.dart';

class MediaProjectionService {
  static const MethodChannel _channel =
  MethodChannel('media_projection_service');

  static Future<void> start() async {
    await _channel.invokeMethod('startService');
  }

  static Future<void> stop() async {
    await _channel.invokeMethod('stopService');
  }
}