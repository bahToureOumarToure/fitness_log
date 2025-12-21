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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec type de sport et date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: sportColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      workout.typeSport,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
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
                  Icons.timer_outlined,
                  '${workout.duree} min',
                ),
                _buildInfoItem(
                  context,
                  Icons.local_fire_department_outlined,
                  '${workout.caloriesBrulees} kcal',
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.note_outlined,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        workout.notes!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Actions
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onDuplicate != null)
                  TextButton.icon(
                    onPressed: onDuplicate,
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Dupliquer'),
                  ),
                if (onEdit != null)
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Modifier'),
                  ),
                if (onDelete != null)
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('Supprimer'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
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

