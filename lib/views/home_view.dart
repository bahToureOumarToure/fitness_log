import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workout_provider.dart';
import '../widgets/chart_widget.dart';
import '../widgets/workout_card.dart';

/// Dashboard dynamique avec statistiques et workouts récents
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutsAsync = ref.watch(workoutListProvider);
    final statsAsync = ref.watch(workoutStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Log'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(workoutListProvider);
          ref.invalidate(workoutStatsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistiques globales
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistiques',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    statsAsync.when(
                      data: (stats) => _buildStatsCards(context, stats),
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (error, stack) => Center(
                        child: Text('Erreur: $error'),
                      ),
                    ),
                  ],
                ),
              ),
              // Graphique de progression hebdomadaire
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progression Hebdomadaire',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    workoutsAsync.when(
                      data: (workouts) => ChartWidget(
                        workouts: workouts,
                        metric: 'calories',
                      ),
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (error, stack) => Center(
                        child: Text('Erreur: $error'),
                      ),
                    ),
                  ],
                ),
              ),
              // Workouts récents
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Séances Récentes',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigation vers la liste complète
                          },
                          child: const Text('Voir tout'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    workoutsAsync.when(
                      data: (workouts) {
                        final recentWorkouts = workouts.take(5).toList();
                        if (recentWorkouts.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text('Aucune séance enregistrée'),
                            ),
                          );
                        }
                        return Column(
                          children: recentWorkouts
                              .map((workout) => WorkoutCard(workout: workout))
                              .toList(),
                        );
                      },
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (error, stack) => Center(
                        child: Text('Erreur: $error'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, stats) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Calories',
            '${stats.totalCalories}',
            Icons.local_fire_department,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Durée',
            '${stats.totalDuree} min',
            Icons.timer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Séances',
            '${stats.nombreSeances}',
            Icons.fitness_center,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

