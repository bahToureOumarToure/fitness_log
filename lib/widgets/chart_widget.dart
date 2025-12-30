import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/workout.dart';
import '../core/utils/date_utils.dart' as app_date_utils;

class ChartWidget extends StatelessWidget {
  final List<Workout> workouts;
  final String metric;
  final String mode;

  const ChartWidget({
    super.key,
    required this.workouts,
    this.metric = 'calories',
    this.mode = 'weekly',
  });

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return const Center(child: Text('Aucune donnée à afficher'));
    }

    final chartData = mode == 'daily' ? _groupByDay(workouts) : _groupByWeek(workouts);

    return LayoutBuilder(
      builder: (context, constraints) {
        return LineChart(
          LineChartData(
            // --- GRILLE ---
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false, // Plus propre sans lignes verticales
              horizontalInterval: _getInterval(chartData),
              getDrawingHorizontalLine: (value) => FlLine(
                color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.2),
                strokeWidth: 1,
              ),
            ),
            // --- TITRES ET AXES ---
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= 0 && value.toInt() < chartData.length) {
                      return Text(
                        chartData[value.toInt()]['label'],
                        style: TextStyle(
                          fontSize: 9,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) => Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      fontSize: 9,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
            // --- BORDURES ET LIMITES ---
            borderData: FlBorderData(show: false), // Suppression bordure pour look épuré
            minX: 0,
            maxX: (chartData.length - 1).toDouble(),
            minY: 0,
            maxY: _getMaxValue(chartData) * 1.2,
            // --- DONNÉES DE LA LIGNE ---
            lineBarsData: [
              LineChartBarData(
                spots: chartData.asMap().entries.map((entry) {
                  return FlSpot(entry.key.toDouble(), (entry.value['value'] as num).toDouble());
                }).toList(),

                isCurved: false, // <--- C'est ici : Lignes droites

                color: Theme.of(context).colorScheme.primary,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      Theme.of(context).colorScheme.primary.withOpacity(0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- LOGIQUE DE CALCUL (Inchangée pour respecter tes données) ---

  List<Map<String, dynamic>> _groupByWeek(List<Workout> workouts) {
    final Map<String, Map<String, dynamic>> weeklyMap = {};
    for (final workout in workouts) {
      final weekRange = app_date_utils.DateUtils.getWeekRange(workout.date);
      final weekKey = app_date_utils.DateUtils.formatDate(weekRange['start']!);
      if (!weeklyMap.containsKey(weekKey)) {
        weeklyMap[weekKey] = {
          'label': '${weekRange['start']!.day}/${weekRange['start']!.month}',
          'value': 0,
        };
      }
      weeklyMap[weekKey]!['value'] = (weeklyMap[weekKey]!['value'] as int) +
          (metric == 'calories' ? workout.caloriesBrulees : workout.duree);
    }
    final sortedEntries = weeklyMap.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return sortedEntries.map((e) => e.value).toList();
  }

  List<Map<String, dynamic>> _groupByDay(List<Workout> workouts) {
    final Map<String, Map<String, dynamic>> dailyMap = {};
    for (final workout in workouts) {
      final dayKey = app_date_utils.DateUtils.formatDate(workout.date);
      if (!dailyMap.containsKey(dayKey)) {
        dailyMap[dayKey] = {
          'label': '${workout.date.day}/${workout.date.month}',
          'value': 0,
        };
      }
      dailyMap[dayKey]!['value'] = (dailyMap[dayKey]!['value'] as int) +
          (metric == 'calories' ? workout.caloriesBrulees : workout.duree);
    }
    final sortedEntries = dailyMap.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return sortedEntries.map((e) => e.value).toList();
  }

  double _getMaxValue(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 100;
    return data.map((e) => (e['value'] as num).toDouble()).reduce((a, b) => a > b ? a : b);
  }

  double _getInterval(List<Map<String, dynamic>> data) {
    final max = _getMaxValue(data);
    return (max / 5) > 0 ? (max / 5) : 20;
  }
}