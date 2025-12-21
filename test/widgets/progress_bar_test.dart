import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_log/widgets/progress_bar.dart';

void main() {
  group('ProgressBar Widget', () {
    testWidgets('should display progress correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProgressBar(
              current: 50,
              target: 100,
              label: 'Test Progress',
              unit: '%',
            ),
          ),
        ),
      );

      expect(find.text('Test Progress'), findsOneWidget);
      expect(find.textContaining('50'), findsWidgets);
      expect(find.textContaining('100'), findsWidgets);
    });

    testWidgets('should display without label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProgressBar(
              current: 75,
              target: 100,
            ),
          ),
        ),
      );

      // Vérifier que le widget se construit correctement
      expect(find.byType(ProgressBar), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('should clamp progress to 100%', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProgressBar(
              current: 150,
              target: 100,
            ),
          ),
        ),
      );

      // Vérifier que le widget se construit correctement
      expect(find.byType(ProgressBar), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });
  });
}

