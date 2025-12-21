import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/workout.dart';
import '../models/stats.dart';
import '../services/sqlite_service.dart';
import '../services/stats_service.dart';

/// Provider pour la liste de toutes les séances
final workoutListProvider = FutureProvider<List<Workout>>((ref) async {
  final sqliteService = SQLiteService();
  return await sqliteService.getWorkouts();
});

/// Provider pour les statistiques agrégées
final workoutStatsProvider = FutureProvider<Stats>((ref) async {
  final statsService = StatsService();
  return await statsService.calculateStats();
});

/// Provider pour les statistiques hebdomadaires
final workoutWeeklyStatsProvider =
    FutureProvider.family<Stats, DateTime>((ref, weekDate) async {
  final statsService = StatsService();
  return await statsService.calculateWeeklyStats(weekDate);
});

/// StateNotifier pour ajouter une séance
class AddWorkoutNotifier extends StateNotifier<AsyncValue<void>> {
  AddWorkoutNotifier() : super(const AsyncValue.data(null));

  Future<void> addWorkout(Workout workout) async {
    state = const AsyncValue.loading();
    try {
      final sqliteService = SQLiteService();
      await sqliteService.createWorkout(workout);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final addWorkoutProvider =
    StateNotifierProvider<AddWorkoutNotifier, AsyncValue<void>>((ref) {
  return AddWorkoutNotifier();
});

/// StateNotifier pour modifier une séance
class UpdateWorkoutNotifier extends StateNotifier<AsyncValue<void>> {
  UpdateWorkoutNotifier(this.ref) : super(const AsyncValue.data(null));
  final Ref ref;

  Future<void> updateWorkout(Workout workout) async {
    state = const AsyncValue.loading();
    try {
      final sqliteService = SQLiteService();
      await sqliteService.updateWorkout(workout);
      state = const AsyncValue.data(null);
      // Invalider la liste pour rafraîchir
      ref.invalidate(workoutListProvider);
      ref.invalidate(workoutStatsProvider);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final updateWorkoutProvider =
    StateNotifierProvider<UpdateWorkoutNotifier, AsyncValue<void>>((ref) {
  return UpdateWorkoutNotifier(ref);
});

/// StateNotifier pour supprimer une séance
class DeleteWorkoutNotifier extends StateNotifier<AsyncValue<void>> {
  DeleteWorkoutNotifier(this.ref) : super(const AsyncValue.data(null));
  final Ref ref;

  Future<void> deleteWorkout(int id) async {
    state = const AsyncValue.loading();
    try {
      final sqliteService = SQLiteService();
      await sqliteService.deleteWorkout(id);
      state = const AsyncValue.data(null);
      // Invalider la liste pour rafraîchir
      ref.invalidate(workoutListProvider);
      ref.invalidate(workoutStatsProvider);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final deleteWorkoutProvider =
    StateNotifierProvider<DeleteWorkoutNotifier, AsyncValue<void>>((ref) {
  return DeleteWorkoutNotifier(ref);
});

/// StateNotifier pour dupliquer une séance (obligatoire)
class DuplicateWorkoutNotifier extends StateNotifier<AsyncValue<void>> {
  DuplicateWorkoutNotifier(this.ref) : super(const AsyncValue.data(null));
  final Ref ref;

  Future<void> duplicateWorkout(int id) async {
    state = const AsyncValue.loading();
    try {
      final sqliteService = SQLiteService();
      await sqliteService.duplicateWorkout(id);
      state = const AsyncValue.data(null);
      // Invalider la liste pour rafraîchir
      ref.invalidate(workoutListProvider);
      ref.invalidate(workoutStatsProvider);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final duplicateWorkoutProvider =
    StateNotifierProvider<DuplicateWorkoutNotifier, AsyncValue<void>>((ref) {
  return DuplicateWorkoutNotifier(ref);
});

