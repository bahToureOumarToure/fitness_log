import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_log/models/stats.dart';

void main() {
  group('Stats Model', () {
    test('Stats.empty should create empty stats', () {
      final stats = Stats.empty();

      expect(stats.totalCalories, 0);
      expect(stats.totalDuree, 0);
      expect(stats.moyenneCaloriesHebdo, 0.0);
      expect(stats.moyenneDureeHebdo, 0.0);
      expect(stats.nombreSeances, 0);
      expect(stats.caloriesParType, isEmpty);
      expect(stats.dureeParType, isEmpty);
    });

    test('Stats should initialize with provided values', () {
      final stats = Stats(
        totalCalories: 1000,
        totalDuree: 120,
        moyenneCaloriesHebdo: 500.0,
        moyenneDureeHebdo: 60.0,
        nombreSeances: 5,
        caloriesParType: {'Cardio': 600, 'Musculation': 400},
        dureeParType: {'Cardio': 60, 'Musculation': 60},
      );

      expect(stats.totalCalories, 1000);
      expect(stats.totalDuree, 120);
      expect(stats.moyenneCaloriesHebdo, 500.0);
      expect(stats.moyenneDureeHebdo, 60.0);
      expect(stats.nombreSeances, 5);
      expect(stats.caloriesParType['Cardio'], 600);
      expect(stats.dureeParType['Cardio'], 60);
    });
  });
}






