import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:bincang_visual_flutter/di/dependency_injection.dart';
import 'package:bincang_visual_flutter/utils/old_signaling/signaling.dart';

import 'features/room/presentation/username_input_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDependency();
  initWebSocketDependency();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UsernameInputPage(),
    );
  }
}



