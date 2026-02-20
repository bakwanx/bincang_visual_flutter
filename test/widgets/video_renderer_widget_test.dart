import 'package:bincang_visual_flutter/features/meeting/presentation/widgets/video_renderer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VideoRendererWidget', () {
    testWidgets('displays participant name', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoRendererWidget(
              participantName: 'John Doe',
              isVideoOff: true,
            ),
          ),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('shows mute icon when muted', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoRendererWidget(
              participantName: 'John Doe',
              isMuted: true,
              isVideoOff: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.mic_off), findsOneWidget);
    });

    testWidgets('displays avatar when video is off', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoRendererWidget(
              participantName: 'John Doe',
              isVideoOff: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('JD'), findsOneWidget);
    });
  });
}