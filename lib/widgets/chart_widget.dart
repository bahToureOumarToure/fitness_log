import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/workout.dart';
import '../core/utils/date_utils.dart' as app_date_utils;
import '../core/constants/app_constants.dart';
import 'package:flutter/material.dart';

/// Graphique avec fl_chart pour visualisation des statistiques
/// Supporte les modes 'weekly' (par semaine) et 'daily' (par jour)
class ChartWidget extends StatelessWidget {
  final List<Workout> workouts;
  final String metric; // 'calories' ou 'duration'
  final String mode; // 'weekly' ou 'daily'

  const ChartWidget({
    super.key,
    required this.workouts,
    this.metric = 'calories',
    this.mode = 'weekly',
  });

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return Center(
        child: Text('Aucune donnée à afficher',
        style: TextStyle(
          color:  Theme.of(context).textTheme.bodyMedium!.color,
        ),),
      );
    }

    // Grouper les workouts selon le mode
    final chartData = mode == 'daily' ? _groupByDay(workouts) : _groupByWeek(workouts);

    if (chartData.isEmpty) {
      return const Center(
        child: Text('Aucune donnée à afficher'),
      );
    }

    return Container(
      height: 400,
      padding: const EdgeInsets.all(0.1),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: _getInterval(chartData),
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Theme.of(context).colorScheme.error,
                strokeWidth: 0,
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
                reservedSize: 100,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < chartData.length) {
                    final label = chartData[value.toInt()]['label'] as String;
                    return Padding(
                      padding: const EdgeInsets.only(top: 1.0),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 8,
                          color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold
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
                      fontSize: 8,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold
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
          maxX: (chartData.length - 1).toDouble(),
          minY: 0,
          maxY: _getMaxValue(chartData) * 1.1,
          lineBarsData: [
            LineChartBarData(
              spots: chartData.asMap().entries.map((entry) {
                return FlSpot(
                  entry.key.toDouble(),
                  (entry.value['value'] as num).toDouble(),
                );
              }).toList(),
              isCurved: true,
              color: Theme.of(context).colorScheme.secondary,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true,),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withValues(alpha: 0.2),
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

  double _getInterval(List<Map<String, dynamic>> chartData) {
    final max = _getMaxValue(chartData);
    if (max <= 100) return 20;
    if (max <= 500) return 100;
    if (max <= 1000) return 200;
    return 500;
  }

  /// Groupe les workouts par jour
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

      if (metric == 'calories') {
        dailyMap[dayKey]!['value'] =
            (dailyMap[dayKey]!['value'] as int) + workout.caloriesBrulees;
      } else {
        dailyMap[dayKey]!['value'] =
            (dailyMap[dayKey]!['value'] as int) + workout.duree;
      }
    }

    // Trier par date
    final sortedEntries = dailyMap.entries.toList()
      ..sort((a, b) {
        final dateA = DateTime.parse(a.key.split('/').reversed.join('-'));
        final dateB = DateTime.parse(b.key.split('/').reversed.join('-'));
        return dateA.compareTo(dateB);
      });

    return sortedEntries.map((e) => e.value).toList();
  }
}

