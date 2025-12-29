/// Modèle Stats pour agrégations statistiques
/// Calculé à la volée depuis les workouts
class Stats {
  final int totalCalories;
  final int totalDuree; // En minutes
  final double moyenneCaloriesHebdo;
  final double moyenneDureeHebdo;
  final int nombreSeances;
  final Map<String, int> caloriesParType; // Calories par type de sport
  final Map<String, int> dureeParType; // Durée par type de sport

  Stats({
    required this.totalCalories,
    required this.totalDuree,
    required this.moyenneCaloriesHebdo,
    required this.moyenneDureeHebdo,
    required this.nombreSeances,
    required this.caloriesParType,
    required this.dureeParType,
  });

  /// Crée un Stats vide
  factory Stats.empty() {
    return Stats(
      totalCalories: 0,
      totalDuree: 0,
      moyenneCaloriesHebdo: 0.0,
      moyenneDureeHebdo: 0.0,
      nombreSeances: 0,
      caloriesParType: {},
      dureeParType: {},
    );
  }

  @override
  String toString() {
    return 'Stats(totalCalories: $totalCalories, totalDuree: $totalDuree, moyenneCaloriesHebdo: $moyenneCaloriesHebdo, moyenneDureeHebdo: $moyenneDureeHebdo, nombreSeances: $nombreSeances)';
  }
}
