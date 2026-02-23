import 'package:bincang_visual_flutter/di/dependency_injection.dart';
import 'package:bincang_visual_flutter/utils/log/print_debug_log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb){
    usePathUrlStrategy();
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await initDependency();
  // await Hive.init(path);
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    printDebugLog(tag: 'Flutter Error', message: '${details.exception}');
    printDebugLog(tag: 'Stack trace', message: '${details.stack}');
  };

  runApp(const BincangVisualApp());
}


