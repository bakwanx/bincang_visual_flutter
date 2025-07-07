import 'package:flutter/foundation.dart';
import 'dart:developer' as dev;

void printDebugLog({String tag = '', required final String message}) {
  if (kDebugMode) {
    if (kIsWeb) {
      print('$tag: $message');
    } else {
      dev.log(message, name: tag);
    }
  }
}
