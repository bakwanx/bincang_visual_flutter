import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../features/meeting/presentation/home_page.dart';
import '../../features/meeting/presentation/meeting_preview_page.dart';
import '../../features/meeting/presentation/meeting_room_page.dart';
import '../../features/meeting/presentation/room_link_handler_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/room/:roomId',
        builder: (context, state) {
          final roomId = state.pathParameters['roomId']!;
          return RoomLinkHandlerPage(roomId: roomId);
        },
      ),
      GoRoute(
        path: '/preview',
        name: 'preview',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final roomId = extra?['roomId'] as String? ?? '';
          final isNewMeeting = extra?['isNewMeeting'] as bool? ?? false;
          return MeetingPreviewPage(roomId: roomId, isNewMeeting: isNewMeeting);
        },
      ),
      GoRoute(
        path: '/meeting',
        name: 'meeting',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/');
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final roomId = extra['roomId'] as String;
          final displayName = extra['displayName'] as String;
          final initialCameraState = extra['initialCameraState'] as bool? ?? true;
          final initialMicState = extra['initialMicState'] as bool? ?? true;

          return MeetingRoomPage(
            roomId: roomId,
            displayName: displayName,
            initialCameraState: initialCameraState,
            initialMicState: initialMicState,
          );
        },
      ),
    ],

    errorBuilder:
        (context, state) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Page not found: ${state.uri}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Go Home'),
                ),
              ],
            ),
          ),
        ),
  );
}
