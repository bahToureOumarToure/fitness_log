import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_log/widgets/workout_card.dart';
import 'package:fitness_log/models/workout.dart';

void main() {
  group('WorkoutCard Widget', () {
    testWidgets('should display workout information', (WidgetTester tester) async {
      final workout = Workout(
        id: 1,
        typeSport: 'Cardio',
        duree: 30,
        caloriesBrulees: 300,
        date: DateTime(2024, 1, 1),
        notes: 'Test notes',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WorkoutCard(workout: workout),
          ),
        ),
      );

      expect(find.text('Cardio'), findsOneWidget);
      expect(find.text('30 min'), findsOneWidget);
      expect(find.text('300 kcal'), findsOneWidget);
      expect(find.text('Test notes'), findsOneWidget);
    });

    testWidgets('should call onEdit when edit button is tapped', (WidgetTester tester) async {
      bool editCalled = false;
      final workout = Workout(
        id: 1,
        typeSport: 'Cardio',
        duree: 30,
        caloriesBrulees: 300,
        date: DateTime(2024, 1, 1),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WorkoutCard(
              workout: workout,
              onEdit: () {
                editCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Modifier'));
      await tester.pump();

      expect(editCalled, true);
    });

    testWidgets('should not display notes section when notes is null', (WidgetTester tester) async {
      final workout = Workout(
        id: 1,
        typeSport: 'Cardio',
        duree: 30,
        caloriesBrulees: 300,
        date: DateTime(2024, 1, 1),
        notes: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WorkoutCard(workout: workout),
          ),
        ),
      );

      expect(find.byIcon(Icons.note_outlined), findsNothing);
    });
  });
}

