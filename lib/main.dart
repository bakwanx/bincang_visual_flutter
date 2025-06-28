import 'package:bincang_visual_flutter/src/presentation/cubit/remote_cubit.dart';
import 'package:bincang_visual_flutter/src/presentation/cubit/signaling_cubit.dart';
import 'package:bincang_visual_flutter/src/presentation/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:bincang_visual_flutter/di/dependency_injection.dart';
import 'package:bincang_visual_flutter/utils/old_signaling/signaling.dart';

import 'src/presentation/username_input_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDependency();
  initWebSocketDependency();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // "yOR-gUMo-WQN"
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di<SignalingCubit>(),
        ),
        BlocProvider(
          create: (context) => di<RemoteCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Color(0XFFFCFCFF),
        ),
        home: UsernameInputPage(roomId: "yOR-gUMo-WQN"),
      ),
    );
  }
}



