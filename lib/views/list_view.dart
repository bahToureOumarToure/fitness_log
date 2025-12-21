import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workout_provider.dart';
import '../widgets/workout_card.dart';
import '../core/constants/app_constants.dart';
import '../models/workout.dart';

/// Liste des séances (obligatoire selon cahier des charges)
class WorkoutListView extends ConsumerStatefulWidget {
  const WorkoutListView({super.key});

  @override
  ConsumerState<WorkoutListView> createState() => _WorkoutListViewState();
}

class _WorkoutListViewState extends ConsumerState<WorkoutListView> {
  String? _selectedTypeFilter;
  DateTime? _selectedDateFilter;

  @override
  Widget build(BuildContext context) {
    final workoutsAsync = ref.watch(workoutListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Séances'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: workoutsAsync.when(
        data: (workouts) {
          // Appliquer les filtres
          var filteredWorkouts = workouts;

          if (_selectedTypeFilter != null) {
            filteredWorkouts = filteredWorkouts
                .where((w) => w.typeSport == _selectedTypeFilter)
                .toList();
          }

          if (_selectedDateFilter != null) {
            filteredWorkouts = filteredWorkouts
                .where((w) =>
                    w.date.year == _selectedDateFilter!.year &&
                    w.date.month == _selectedDateFilter!.month &&
                    w.date.day == _selectedDateFilter!.day)
                .toList();
          }

          if (filteredWorkouts.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('Aucune séance trouvée'),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(workoutListProvider);
            },
            child: ListView.builder(
              itemCount: filteredWorkouts.length,
              itemBuilder: (context, index) {
                final workout = filteredWorkouts[index];
                return WorkoutCard(
                  workout: workout,
                  onEdit: () => _editWorkout(context, workout),
                  onDelete: () => _deleteWorkout(context, workout),
                  onDuplicate: () => _duplicateWorkout(context, workout),
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Erreur: $error'),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    final dialogContext = context;
    showDialog(
      context: dialogContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Filtres'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Filtre par type
            DropdownButtonFormField<String>(
              initialValue: _selectedTypeFilter,
              decoration: const InputDecoration(
                labelText: 'Type de sport',
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Tous'),
                ),
                ...AppConstants.sportTypes.map(
                  (type) => DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedTypeFilter = value;
                });
                Navigator.pop(dialogContext);
              },
            ),
            const SizedBox(height: 16),
            // Filtre par date
            Builder(
              builder: (datePickerContext) => ElevatedButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: datePickerContext,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null && mounted) {
                    setState(() {
                      _selectedDateFilter = date;
                    });
                    Navigator.pop(dialogContext);
                  }
                },
                child: Text(
                  _selectedDateFilter == null
                      ? 'Sélectionner une date'
                      : 'Date: ${_selectedDateFilter!.day}/${_selectedDateFilter!.month}/${_selectedDateFilter!.year}',
                ),
              ),
            ),
            if (_selectedDateFilter != null)
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedDateFilter = null;
                  });
                  Navigator.pop(dialogContext);
                },
                child: const Text('Effacer la date'),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedTypeFilter = null;
                _selectedDateFilter = null;
              });
              Navigator.pop(dialogContext);
            },
            child: const Text('Réinitialiser'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _editWorkout(BuildContext context, Workout workout) {
    Navigator.pushNamed(
      context,
      '/add-workout',
      arguments: workout,
    );
  }

  void _deleteWorkout(BuildContext context, Workout workout) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la séance'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer cette séance ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
                  await ref.read(deleteWorkoutProvider.notifier).deleteWorkout(
                        workout.id!,
                      );
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Séance supprimée')),
              );
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _duplicateWorkout(BuildContext context, Workout workout) async {
    await ref.read(duplicateWorkoutProvider.notifier).duplicateWorkout(
          workout.id!,
        );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Séance dupliquée')),
    );
  }
}

