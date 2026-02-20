import 'package:bincang_visual_flutter/features/meeting/presentation/widgets/video_renderer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bincang_visual_flutter/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Meeting Flow Integration Test', () {
    testWidgets('Complete meeting flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify home page
      expect(find.text('Bincang Visual'), findsOneWidget);
      expect(find.text('New Meeting'), findsOneWidget);

      // Tap new meeting button
      await tester.tap(find.text('New Meeting'));
      await tester.pumpAndSettle();

      // Enter meeting name
      await tester.enterText(
        find.byType(TextField),
        'Integration Test Meeting',
      );
      await tester.tap(find.text('Start'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify meeting room loaded
      expect(find.byType(VideoRendererWidget), findsWidgets);
      expect(find.byIcon(Icons.mic), findsOneWidget);
      expect(find.byIcon(Icons.videocam), findsOneWidget);

      // Test mute toggle
      await tester.tap(find.byIcon(Icons.mic));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.mic_off), findsOneWidget);

      // Test video toggle
      await tester.tap(find.byIcon(Icons.videocam));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.videocam_off), findsOneWidget);

      // Test chat
      await tester.tap(find.byIcon(Icons.chat));
      await tester.pumpAndSettle();
      expect(find.text('Meeting Chat'), findsOneWidget);

      // Send a message
      await tester.enterText(
        find.byType(TextField).last,
        'Test message',
      );
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();
      expect(find.text('Test message'), findsOneWidget);

      // Leave meeting
      await tester.tap(find.byIcon(Icons.call_end));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Leave'));
      await tester.pumpAndSettle();

      // Verify back to home
      expect(find.text('New Meeting'), findsOneWidget);
    });
  });
}