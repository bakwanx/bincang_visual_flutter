import 'package:bincang_visual_flutter/di/dependency_injection.dart';
import 'package:bincang_visual_flutter/src/presentation/cubit/remote_cubit.dart';
import 'package:bincang_visual_flutter/src/presentation/dashboard_page.dart';
import 'package:bincang_visual_flutter/src/presentation/preview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDependency();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // "L3F-awjn-iSo"
    return MultiBlocProvider(
      providers: [
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
        home: DashboardPage(),
      ),
    );
  }
}



