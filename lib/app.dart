import 'package:bincang_visual_flutter/core/router/app_router.dart';
import 'package:bincang_visual_flutter/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:bincang_visual_flutter/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:bincang_visual_flutter/features/calendar/presentation/cubit/calendar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'core/theme/app_theme.dart';
import 'di/dependency_injection.dart';
import 'features/analytics/presentation/analytics_page.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/calendar/presentation/calendar_page.dart';
import 'features/meeting/presentation/cubit/meeting_cubit.dart';
import 'features/meeting/presentation/home_page.dart';
import 'features/meeting/presentation/join_meeting_page.dart';
import 'features/meeting/presentation/meeting_preview_page.dart';
import 'features/meeting/presentation/meeting_room_page.dart';
import 'features/settings/presentation/settings_page.dart';

class BincangVisualApp extends StatelessWidget {
  const BincangVisualApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di<MeetingCubit>()),
        BlocProvider(create: (_) => di<AuthCubit>()),
        BlocProvider(create: (_) => di<AnalyticsCubit>()),
        BlocProvider(create: (_) => di<CalendarCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Bincang Visual',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
        // routes: {
        //   '/': (context) => const AuthWrapper(),
        //   '/login': (context) => const LoginPage(),
        //   '/home': (context) => const HomePage(),
        //   '/join': (context) => const JoinMeetingPage(),
        //   '/calendar': (context) => const CalendarPage(),
        //   '/analytics': (context) => const AnalyticsPage(),
        //   '/settings': (context) => const SettingsPage(),
        // },
        // onGenerateRoute: (settings) {
        //   switch (settings.name) {
        //     case '/':
        //       return MaterialPageRoute(
        //         builder: (_) => const HomePage(),
        //       );
        //
        //     case '/preview':
        //       final args = settings.arguments as Map<String, dynamic>;
        //       return MaterialPageRoute(
        //         builder: (_) => MeetingPreviewPage(
        //           roomId: args['roomId'] as String,
        //           isNewMeeting: args['isNewMeeting'] as bool,
        //         ),
        //       );
        //
        //     case '/meeting':
        //       final args = settings.arguments as Map<String, dynamic>;
        //       return MaterialPageRoute(
        //         builder: (_) => MeetingRoomPage(
        //           roomId: args['roomId'] as String,
        //           displayName: args['displayName'] as String,
        //           initialCameraState: args['initialCameraState'] as bool? ?? true,
        //           initialMicState: args['initialMicState'] as bool? ?? true,
        //         ),
        //       );
        //
        //     default:
        //       return MaterialPageRoute(
        //         builder: (_) => const HomePage(),
        //       );
        //   }
        // },
      )
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is Authenticated) {
          return const HomePage();
        }

        return const LoginPage();
      },
    );
  }
}