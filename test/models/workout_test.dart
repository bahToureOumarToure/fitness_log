import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_log/models/workout.dart';

void main() {
  group('Workout Model', () {
    test('toMap should convert Workout to Map correctly', () {
      final workout = Workout(
        id: 1,
        typeSport: 'Cardio',
        duree: 30,
        caloriesBrulees: 300,
        date: DateTime(2024, 1, 1),
        notes: 'Test notes',
      );

      final map = workout.toMap();

      expect(map['id'], 1);
      expect(map['typeSport'], 'Cardio');
      expect(map['duree'], 30);
      expect(map['caloriesBrulées'], 300);
      expect(map['date'], '2024-01-01T00:00:00.000');
      expect(map['notes'], 'Test notes');
    });

    test('fromMap should create Workout from Map correctly', () {
      final map = {
        'id': 1,
        'typeSport': 'Cardio',
        'duree': 30,
        'caloriesBrulées': 300,
        'date': '2024-01-01T00:00:00.000',
        'notes': 'Test notes',
      };

      final workout = Workout.fromMap(map);

      expect(workout.id, 1);
      expect(workout.typeSport, 'Cardio');
      expect(workout.duree, 30);
      expect(workout.caloriesBrulees, 300);
      expect(workout.date, DateTime(2024, 1, 1));
      expect(workout.notes, 'Test notes');
    });

    test('copyWith should create a copy with modified values', () {
      final original = Workout(
        id: 1,
        typeSport: 'Cardio',
        duree: 30,
        caloriesBrulees: 300,
        date: DateTime(2024, 1, 1),
        notes: 'Original notes',
      );

      final copied = original.copyWith(
        duree: 45,
        caloriesBrulees: 450,
      );

      expect(copied.id, 1);
      expect(copied.typeSport, 'Cardio');
      expect(copied.duree, 45);
      expect(copied.caloriesBrulees, 450);
      expect(copied.date, DateTime(2024, 1, 1));
      expect(copied.notes, 'Original notes');
    });

    test('fromMap should handle null notes', () {
      final map = {
        'id': 1,
        'typeSport': 'Cardio',
        'duree': 30,
        'caloriesBrulées': 300,
        'date': '2024-01-01T00:00:00.000',
        'notes': null,
      };

      final workout = Workout.fromMap(map);

      expect(workout.notes, null);
    });
  });
}






