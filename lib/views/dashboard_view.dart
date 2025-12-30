import 'package:fitness_log/widgets/AppBarTemplate.dart';
import 'package:fitness_log/widgets/drawer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workout_provider.dart';
import '../widgets/chart_widget.dart';
import '../widgets/pie_chart_widget.dart';
import '../core/utils/date_utils.dart' as app_date_utils;

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutsAsync = ref.watch(workoutListProvider);
    final now = DateTime.now();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: const Drawer_page(),
      appBar: const AppBartemplate(title: 'Dashboard'), // Correction faute frappe
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
              // --- TITRE SECTION ---
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Center(
                  child: Text(
                    'Statistiques de la semaine',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),

              // --- CAROUSEL DES GRAPHIQUES ---
              SizedBox(
                height: 400,
                // Augmenté pour laisser respirer les graphiques
                child: PageView(
                  controller: PageController(viewportFraction: 0.92),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // SLIDE 1: Calories par jour
                    _buildCarouselCard(
                      context,
                      title: 'Calories / jour',
                      child: workoutsAsync.when(
                        data: (workouts) {
                          final weekRange = app_date_utils.DateUtils.getWeekRange(now);
                          final weekWorkouts = workouts.where((w) {
                            return w.date.isAfter(weekRange['start']!.subtract(const Duration(days: 1))) &&
                                w.date.isBefore(weekRange['end']!.add(const Duration(days: 1)));
                          }).toList();
                          return ChartWidget(workouts: weekWorkouts, metric: 'calories', mode: 'daily');
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Center(child: Text('Erreur: $error')),
                      ),
                    ),

                    // SLIDE 2: Évolution Hebdomadaire
                    _buildCarouselCard(
                      context,
                      title: 'Évolution hebdomadaire',
                      child: workoutsAsync.when(
                        data: (workouts) => ChartWidget(workouts: workouts, metric: 'calories', mode: 'weekly'),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Center(child: Text('Erreur: $error')),
                      ),
                    ),

                    // SLIDE 3: Répartition (Pie Chart)
                    _buildCarouselCard(
                      context,
                      title: 'Prestation de la Semaine',
                      child: workoutsAsync.when(
                        data: (workouts) {
                          final weekRange = app_date_utils.DateUtils.getWeekRange(now);
                          final weekWorkouts = workouts.where((w) {
                            return w.date.isAfter(weekRange['start']!.subtract(const Duration(days: 1))) &&
                                w.date.isBefore(weekRange['end']!.add(const Duration(days: 1)));
                          }).toList();
                          return PieChartWidget(workouts: weekWorkouts, metric: 'calories');
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Center(child: Text('Erreur: $error')),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER POUR LE STYLE DES CARTES DU CAROUSEL ---
  Widget _buildCarouselCard(BuildContext context, {required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}