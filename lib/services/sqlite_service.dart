import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/workout.dart';

/// Service SQLite pour la persistance des données
/// Singleton avec initialisation de la DB
class SQLiteService {
  static final SQLiteService _instance = SQLiteService._internal();
  factory SQLiteService() => _instance;
  SQLiteService._internal();

  static Database? _database;

  /// Obtient l'instance de la base de données
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialise la base de données
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'fitness_log.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Crée les tables lors de la première création de la DB
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE workouts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        typeSport TEXT NOT NULL,
        duree INTEGER NOT NULL,
        caloriesBrulées INTEGER NOT NULL,
        date TEXT NOT NULL,
        notes TEXT
      )
    ''');
  }

  /// Ajouter une séance
  Future<int> createWorkout(Workout workout) async {
    final db = await database;
    return await db.insert(
      'workouts',
      workout.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Récupérer toutes les séances
  Future<List<Workout>> getWorkouts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workouts',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Workout.fromMap(maps[i]));
  }

  /// Récupérer une séance par ID
  Future<Workout?> getWorkoutById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workouts',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Workout.fromMap(maps.first);
  }

  /// Modifier une séance
  Future<int> updateWorkout(Workout workout) async {
    final db = await database;
    return await db.update(
      'workouts',
      workout.toMap(),
      where: 'id = ?',
      whereArgs: [workout.id],
    );
  }

  /// Supprimer une séance
  Future<int> deleteWorkout(int id) async {
    final db = await database;
    return await db.delete(
      'workouts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Dupliquer une séance (obligatoire selon cahier des charges)
  Future<int> duplicateWorkout(int id) async {
    final workout = await getWorkoutById(id);
    if (workout == null) {
      throw Exception('Workout not found');
    }
    // Créer une copie avec une nouvelle date (aujourd'hui)
    final duplicatedWorkout = workout.copyWith(
      id: null, // Nouveau ID auto-généré
      date: DateTime.now(),
    );
    return await createWorkout(duplicatedWorkout);
  }

  /// Filtrer par période
  Future<List<Workout>> getWorkoutsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workouts',
      where: 'date >= ? AND date <= ?',
      whereArgs: [
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Workout.fromMap(maps[i]));
  }

  /// Filtrer par type de sport
  Future<List<Workout>> getWorkoutsByType(String typeSport) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workouts',
      where: 'typeSport = ?',
      whereArgs: [typeSport],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Workout.fromMap(maps[i]));
  }

  /// Séances d'une semaine donnée
  Future<List<Workout>> getWorkoutsByWeek(DateTime weekDate) async {
    // Calculer le début et la fin de la semaine (lundi à dimanche)
    final startOfWeek = weekDate.subtract(Duration(days: weekDate.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    // Normaliser les dates (minuit)
    final start = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    final end = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59);
    
    return await getWorkoutsByDateRange(start, end);
  }

  /// Fermer la base de données
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

