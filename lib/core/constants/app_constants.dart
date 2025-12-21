/// Constantes de l'application
class AppConstants {
  // Types de sport disponibles
  static const List<String> sportTypes = [
    'Cardio',
    'Musculation',
    'Marche',
    'Course',
    'Yoga',
  ];

  // Durées par défaut (en minutes)
  static const int defaultDuration = 30;
  static const List<int> commonDurations = [15, 30, 45, 60, 90, 120];

  // Calories par défaut par type de sport (par minute)
  static const Map<String, int> defaultCaloriesPerMinute = {
    'Cardio': 10,
    'Musculation': 8,
    'Marche': 5,
    'Course': 12,
    'Yoga': 3,
  };

  // Formats de date
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String timeFormat = 'HH:mm';

  // Nombre de workouts récents à afficher sur le dashboard
  static const int recentWorkoutsCount = 5;

  // Nombre de jours pour les statistiques par défaut
  static const int defaultStatsDays = 7;
}

