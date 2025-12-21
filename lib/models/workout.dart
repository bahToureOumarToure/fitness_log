/// Modèle Workout selon le cahier des charges
/// Représente une séance d'entraînement avec tous ses attributs
class Workout {
  final int? id;
  final String typeSport; // Cardio, Musculation, Marche, Course, Yoga
  final int duree; // Durée en minutes
  final int caloriesBrulees; // Estimation calories brûlées
  final DateTime date; // Date de la séance
  final String? notes; // Notes optionnelles

  Workout({
    this.id,
    required this.typeSport,
    required this.duree,
    required this.caloriesBrulees,
    required this.date,
    this.notes,
  });

  /// Convertit le modèle en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'typeSport': typeSport,
      'duree': duree,
      'caloriesBrulées': caloriesBrulees,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  /// Crée un Workout à partir d'une Map (depuis SQLite)
  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'] as int?,
      typeSport: map['typeSport'] as String,
      duree: map['duree'] as int,
      caloriesBrulees: map['caloriesBrulées'] as int,
      date: DateTime.parse(map['date'] as String),
      notes: map['notes'] as String?,
    );
  }

  /// Crée une copie du Workout avec des valeurs modifiées
  Workout copyWith({
    int? id,
    String? typeSport,
    int? duree,
    int? caloriesBrulees,
    DateTime? date,
    String? notes,
  }) {
    return Workout(
      id: id ?? this.id,
      typeSport: typeSport ?? this.typeSport,
      duree: duree ?? this.duree,
      caloriesBrulees: caloriesBrulees ?? this.caloriesBrulees,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'Workout(id: $id, typeSport: $typeSport, duree: $duree, caloriesBrulees: $caloriesBrulees, date: $date, notes: $notes)';
  }
}

