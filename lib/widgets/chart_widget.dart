import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/workout.dart';
import '../core/utils/date_utils.dart' as app_date_utils;

/// Graphique avec fl_chart pour visualisation des statistiques
class ChartWidget extends StatelessWidget {
  final List<Workout> workouts;
  final String metric; // 'calories' ou 'duration'

  const ChartWidget({
    super.key,
    required this.workouts,
    this.metric = 'calories',
  });

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return const Center(
        child: Text('Aucune donnée à afficher'),
      );
    }

    // Grouper les workouts par semaine
    final weeklyData = _groupByWeek(workouts);

    if (weeklyData.isEmpty) {
      return const Center(
        child: Text('Aucune donnée à afficher'),
      );
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _getInterval(weeklyData),
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Theme.of(context).colorScheme.surface,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < weeklyData.length) {
                    final weekLabel = weeklyData[value.toInt()]['label'] as String;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        weekLabel,
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          minX: 0,
          maxX: (weeklyData.length - 1).toDouble(),
          minY: 0,
          maxY: _getMaxValue(weeklyData) * 1.1,
          lineBarsData: [
            LineChartBarData(
              spots: weeklyData.asMap().entries.map((entry) {
                return FlSpot(
                  entry.key.toDouble(),
                  (entry.value['value'] as num).toDouble(),
                );
              }).toList(),
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _groupByWeek(List<Workout> workouts) {
    final Map<String, Map<String, dynamic>> weeklyMap = {};

    for (final workout in workouts) {
      final weekRange = app_date_utils.DateUtils.getWeekRange(workout.date);
      final weekKey = app_date_utils.DateUtils.formatDate(weekRange['start']!);

      if (!weeklyMap.containsKey(weekKey)) {
        weeklyMap[weekKey] = {
          'label': 'Sem ${weekRange['start']!.day}/${weekRange['start']!.month}',
          'value': 0,
        };
      }

      if (metric == 'calories') {
        weeklyMap[weekKey]!['value'] =
            (weeklyMap[weekKey]!['value'] as int) + workout.caloriesBrulees;
      } else {
        weeklyMap[weekKey]!['value'] =
            (weeklyMap[weekKey]!['value'] as int) + workout.duree;
      }
    }

    // Trier par date
    final sortedEntries = weeklyMap.entries.toList()
      ..sort((a, b) {
        final dateA = DateTime.parse(a.key.split('/').reversed.join('-'));
        final dateB = DateTime.parse(b.key.split('/').reversed.join('-'));
        return dateA.compareTo(dateB);
      });

    return sortedEntries.map((e) => e.value).toList();
  }

  double _getMaxValue(List<Map<String, dynamic>> weeklyData) {
    if (weeklyData.isEmpty) return 100;
    return weeklyData
        .map((e) => (e['value'] as num).toDouble())
        .reduce((a, b) => a > b ? a : b);
  }

  double _getInterval(List<Map<String, dynamic>> weeklyData) {
    final max = _getMaxValue(weeklyData);
    if (max <= 100) return 20;
    if (max <= 500) return 100;
    if (max <= 1000) return 200;
    return 500;
  }
}

