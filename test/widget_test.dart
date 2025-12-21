// Tests de base pour l'application Fitness Log

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitness_log/main.dart';

void main() {
  testWidgets('App démarre correctement', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: FitnessLogApp(),
      ),
    );

    // Verify that the app title is displayed
    expect(find.text('Fitness Log'), findsOneWidget);
  });
}
