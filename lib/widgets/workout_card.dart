

import 'package:fitness_log/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/date_utils.dart' as app_date_utils;

/// Carte d'affichage workout avec toutes les informations et actions
class WorkoutCard extends StatelessWidget {
  final Workout workout;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onDuplicate;

  const WorkoutCard({
    super.key,
    required this.workout,
    this.onEdit,
    this.onDelete,
    this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    final sportColor = AppColors.getSportColor(workout.typeSport);
    final  icon = AppConstants.sportIcons[workout.typeSport];


    return Card(
      color: Theme.of(context).colorScheme.onPrimary,

      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // En-tête avec type de sport et date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                 Icon(icon
                 ,color: sportColor,size: 60,)
                    ,
                    Text(
                      workout.typeSport,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                        color: sportColor
                          ),
                    ),
                  ],
                ),
                Text(
                  app_date_utils.DateUtils.formatDate(workout.date),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Informations principales
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  context,
                  Icons.timer_rounded,
                  '${workout.duree} min',AppColors.primaryDark
                )

                ,
                _buildInfoItem(
                  context,
                Icons.local_fire_department_outlined,
                  '${workout.caloriesBrulees} kcal', AppColors.accent

                ),
              ],
            ),
            // Notes si présentes
            if (workout.notes != null && workout.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  workout.notes!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
            // Actions
            const SizedBox(height: 12),
            Row(
mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                if (onDuplicate != null)
                  ElevatedButton.icon(
                    clipBehavior: Clip.antiAlias,
                    onPressed: onDuplicate,
                    icon: const Icon(Icons.copy_rounded, size: 16), label: Text(""),
                  ),
                if (onEdit != null)
                 ElevatedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text(''),
                  ),
                if (onDelete != null)
                 ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, size: 20,),
                    label: const Text(''),

                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String text, Color col) {
    return Row(
      children: [
        Icon(icon, size: 20, color: col),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

