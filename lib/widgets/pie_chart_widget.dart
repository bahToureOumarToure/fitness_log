import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/constants/app_constants.dart';
import '../models/workout.dart';
import '../core/theme/app_colors.dart';

/// Graphique circulaire (Pie Chart) pour la répartition des types d'activités
class PieChartWidget extends StatelessWidget {
  final List<Workout> workouts;
  final String metric; // 'calories' ou 'duration'

  const PieChartWidget({
    super.key,
    required this.workouts,
    this.metric = 'calories',
  });

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('Aucune donnée à afficher',
          style: TextStyle(
            color:  AppColors.error
          ),),
        ),
      );
    }

    // Grouper par type de sport
    final dataByType = <String, double>{};
    for (final workout in workouts) {
      final value = metric == 'calories'
          ? workout.caloriesBrulees.toDouble()
          : workout.duree.toDouble();
      dataByType[workout.typeSport] = (dataByType[workout.typeSport] ?? 0) + value;
    }

    if (dataByType.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('Aucune donnée à afficher'),
        ),
      );
    }

    // Créer les sections du graphique
    final sections = <PieChartSectionData>[];
    final total = dataByType.values.reduce((a, b) => a + b);

    dataByType.forEach((type, value) {
      final percentage = (value / total * 100);
      sections.add(
        PieChartSectionData(
          value: value,
          title: '${percentage.toStringAsFixed(1)}%',
          color: AppColors.getSportColor(type),
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    });

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Graphique
          Expanded(
            flex: 2,
            child: PieChart(
              PieChartData(
                sections: sections,
                sectionsSpace: 4,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Légende
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: dataByType.entries.map((entry) {
                final type = entry.key;
                final value = entry.value;
                final percentage = (value / total * 100);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 50,

                        child: Icon(AppConstants.sportIcons[type],                          color: AppColors.getSportColor(type),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              type,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '${value.toStringAsFixed(0)}${metric == 'calories' ? ' kcal' : ' min'} (${percentage.toStringAsFixed(1)}%)',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

