import '../models/workout.dart';
import '../models/stats.dart';
import 'sqlite_service.dart';

/// Service pour les calculs statistiques
/// Utilise SQLiteService pour récupérer les données
class StatsService {
  final SQLiteService _sqliteService = SQLiteService();

  /// Calcule les statistiques agrégées pour une période donnée
  Future<Stats> calculateStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    List<Workout> workouts;
    
    if (startDate != null && endDate != null) {
      workouts = await _sqliteService.getWorkoutsByDateRange(
        startDate,
        endDate,
      );
    } else {
      workouts = await _sqliteService.getWorkouts();
    }

    if (workouts.isEmpty) {
      return Stats.empty();
    }

    // Calculs totaux
    final totalCalories = workouts.fold<int>(
      0,
      (sum, workout) => sum + workout.caloriesBrulees,
    );
    final totalDuree = workouts.fold<int>(
      0,
      (sum, workout) => sum + workout.duree,
    );

    // Calculs par type de sport
    final caloriesParType = <String, int>{};
    final dureeParType = <String, int>{};

    for (final workout in workouts) {
      caloriesParType[workout.typeSport] =
          (caloriesParType[workout.typeSport] ?? 0) + workout.caloriesBrulees;
      dureeParType[workout.typeSport] =
          (dureeParType[workout.typeSport] ?? 0) + workout.duree;
    }

    // Calculer le nombre de semaines dans la période
    final firstDate = workouts.map((w) => w.date).reduce(
          (a, b) => a.isBefore(b) ? a : b,
        );
    final lastDate = workouts.map((w) => w.date).reduce(
          (a, b) => a.isAfter(b) ? a : b,
        );
    final daysDiff = lastDate.difference(firstDate).inDays;
    final numberOfWeeks = daysDiff > 0 ? (daysDiff / 7).ceil() : 1;

    // Moyennes hebdomadaires
    final moyenneCaloriesHebdo = totalCalories / numberOfWeeks;
    final moyenneDureeHebdo = totalDuree / numberOfWeeks;

    return Stats(
      totalCalories: totalCalories,
      totalDuree: totalDuree,
      moyenneCaloriesHebdo: moyenneCaloriesHebdo,
      moyenneDureeHebdo: moyenneDureeHebdo,
      nombreSeances: workouts.length,
      caloriesParType: caloriesParType,
      dureeParType: dureeParType,
    );
  }

  /// Agrégation par semaine
  Future<Stats> calculateWeeklyStats(DateTime weekDate) async {
    final workouts = await _sqliteService.getWorkoutsByWeek(weekDate);
    
    if (workouts.isEmpty) {
      return Stats.empty();
    }

    final totalCalories = workouts.fold<int>(
      0,
      (sum, workout) => sum + workout.caloriesBrulees,
    );
    final totalDuree = workouts.fold<int>(
      0,
      (sum, workout) => sum + workout.duree,
    );

    final caloriesParType = <String, int>{};
    final dureeParType = <String, int>{};

    for (final workout in workouts) {
      caloriesParType[workout.typeSport] =
          (caloriesParType[workout.typeSport] ?? 0) + workout.caloriesBrulees;
      dureeParType[workout.typeSport] =
          (dureeParType[workout.typeSport] ?? 0) + workout.duree;
    }

    return Stats(
      totalCalories: totalCalories,
      totalDuree: totalDuree,
      moyenneCaloriesHebdo: totalCalories.toDouble(),
      moyenneDureeHebdo: totalDuree.toDouble(),
      nombreSeances: workouts.length,
      caloriesParType: caloriesParType,
      dureeParType: dureeParType,
    );
  }

  /// Somme calories sur période
  Future<int> calculateTotalCalories({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final stats = await calculateStats(
      startDate: startDate,
      endDate: endDate,
    );
    return stats.totalCalories;
  }

  /// Somme durée sur période
  Future<int> calculateTotalDuration({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final stats = await calculateStats(
      startDate: startDate,
      endDate: endDate,
    );
    return stats.totalDuree;
  }

  /// Progression vers objectifs (pour usage futur)
  Future<Map<String, double>> getWorkoutProgress({
    int? targetCalories,
    int? targetDuration,
  }) async {
    final stats = await calculateStats();
    final progress = <String, double>{};

    if (targetCalories != null && targetCalories > 0) {
      progress['calories'] =
          (stats.totalCalories / targetCalories * 100).clamp(0.0, 100.0);
    }

    if (targetDuration != null && targetDuration > 0) {
      progress['duration'] =
          (stats.totalDuree / targetDuration * 100).clamp(0.0, 100.0);
    }

    return progress;
  }
  
  /// Récupère la progression hebdomadaire des calories
  Future<Map<String, double>> getWeeklyCaloriesProgress() async {
    final stats = await calculateWeeklyStats(DateTime.now());
    
    // Objectif de calories hebdomadaire (peut être configurable)
    const double targetCalories = 3500; 
    
    return {
      'current': stats.totalCalories.toDouble(),
      'target': targetCalories,
    };
  }

  /// Calcule les statistiques par jour pour une semaine
  Future<Map<DateTime, Map<String, int>>> getDailyStatsForWeek(
      DateTime weekDate) async {
    final workouts = await _sqliteService.getWorkoutsByWeek(weekDate);
    final dailyStats = <DateTime, Map<String, int>>{};

    for (final workout in workouts) {
      final day = DateTime(
        workout.date.year,
        workout.date.month,
        workout.date.day,
      );

      if (!dailyStats.containsKey(day)) {
        dailyStats[day] = {'calories': 0, 'duration': 0, 'count': 0};
      }

      dailyStats[day]!['calories'] =
          (dailyStats[day]!['calories'] ?? 0) + workout.caloriesBrulees;
      dailyStats[day]!['duration'] =
          (dailyStats[day]!['duration'] ?? 0) + workout.duree;
      dailyStats[day]!['count'] = (dailyStats[day]!['count'] ?? 0) + 1;
    }

    return dailyStats;
  }
}
