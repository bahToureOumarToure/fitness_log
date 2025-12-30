import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/constants/app_constants.dart';
import '../models/workout.dart';
import '../core/theme/app_colors.dart';

class PieChartWidget extends StatelessWidget {
  final List<Workout> workouts;
  final String metric;

  const PieChartWidget({
    super.key,
    required this.workouts,
    this.metric = 'calories',
  });

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return _buildEmptyState();
    }

    final dataByType = <String, double>{};
    for (final workout in workouts) {
      final value = metric == 'calories'
          ? workout.caloriesBrulees.toDouble()
          : workout.duree.toDouble();
      dataByType[workout.typeSport] = (dataByType[workout.typeSport] ?? 0) + value;
    }

    final total = dataByType.values.fold(0.0, (a, b) => a + b);

    final sections = dataByType.entries.map((entry) {
      final percentage = (entry.value / total * 100);
      return PieChartSectionData(
        value: entry.value,
        title: '${percentage.toStringAsFixed(0)}%',
        color: AppColors.getSportColor(entry.key),
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  sectionsSpace: 2,
                  centerSpaceRadius: 45,
                  borderData: FlBorderData(show: true),
                ),
                swapAnimationDuration: const Duration(milliseconds: 800),
                swapAnimationCurve: Curves.easeInOutBack,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: SingleChildScrollView( // Sécurité si trop de types de sports
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: dataByType.entries.map((entry) {
                    return _buildLegendItem(context, entry.key, entry.value, total);
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- WIDGET HELPER : ITEM DE LÉGENDE ---
  Widget _buildLegendItem(BuildContext context, String type, double value, double total) {
    final percentage = (value / total * 100);
    final color = AppColors.getSportColor(type);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(

        mainAxisSize: MainAxisSize.min,
        children: [
          // Petit indicateur de couleur rond
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${value.toStringAsFixed(0)} ${metric == 'calories' ? 'kcal' : 'min'} (${percentage.toStringAsFixed(1)}%)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'Aucune donnée cette semaine',
        style: TextStyle(color: AppColors.error, fontSize: 13),
      ),
    );
  }
}