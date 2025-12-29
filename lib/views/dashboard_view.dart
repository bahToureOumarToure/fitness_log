import 'package:fitness_log/widgets/AppBarTemplate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workout_provider.dart';
import '../widgets/chart_widget.dart';
import '../widgets/pie_chart_widget.dart';
import '../core/utils/date_utils.dart' as app_date_utils;
import '../services/stats_service.dart' as service_stat;

/// Dashboard amélioré avec statistiques visuelles et graphiques
class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutsAsync = ref.watch(workoutListProvider);
    final now = DateTime.now();
    final weeklyStatsAsync = ref.watch(workoutWeeklyStatsProvider(now));

    return Scaffold(
      appBar: AppBar(
        title: AppBartemplate(title: 'Dashoard'),
      ),
      body: RefreshIndicator(

        onRefresh: () async {
          ref.invalidate(workoutListProvider);
          ref.invalidate(workoutWeeklyStatsProvider(now));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistiques hebdomadaires
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Text(
                      'Statistiques de la semaine',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                  ],
                ),
              ),
              // Graphique par jour (calories)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calories / jour',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    workoutsAsync.when(
                      data: (workouts) {
                        final weekWorkouts = workouts.where((w) {
                          final weekRange =
                              app_date_utils.DateUtils.getWeekRange(now);
                          return w.date.isAfter(weekRange['start']!.subtract(
                                const Duration(days: 1),
                              )) &&
                              w.date.isBefore(weekRange['end']!.add(
                                const Duration(days: 1),
                              ));
                        }).toList();
                        return ChartWidget(
                          workouts: weekWorkouts,
                          metric: 'calories',
                          mode: 'daily',
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, stack) => Center(
                        child: Text('Erreur: $error'),
                      ),
                    ),
                  ],
                ),
              ),

              // Graphique d'évolution sur plusieurs semaines
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Évolution hebdomadaire/calories',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    workoutsAsync.when(
                      data: (workouts) => ChartWidget(
                        workouts: workouts,
                        metric: 'calories',
                        mode: 'weekly',
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, stack) => Center(
                        child: Text('Erreur: $error'),
                      ),
                    ),
                  ],
                ),
              ),
              // Graphique circulaire - Répartition des types d'activités
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prestation de la Semmaine',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    workoutsAsync.when(
                      data: (workouts) {
                        final weekWorkouts = workouts.where((w) {
                          final weekRange =
                          app_date_utils.DateUtils.getWeekRange(now);
                          return w.date.isAfter(weekRange['start']!.subtract(
                            const Duration(days: 1),
                          )) &&
                              w.date.isBefore(weekRange['end']!.add(
                                const Duration(days: 1),
                              ));
                        }).toList();
                        return PieChartWidget(
                          workouts: weekWorkouts,
                          metric: 'calories',
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
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

  Widget _buildWeeklyStatsCards(BuildContext context, stats) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Calories',
            '${stats.totalCalories}',
            Icons.local_fire_department,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Durée',
            '${stats.totalDuree} min',
            Icons.timer,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Séances',
            '${stats.nombreSeances}',
            Icons.fitness_center,
            Colors.green,
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
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("test"),
            Icon(icon, size: 32, color: color),
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

