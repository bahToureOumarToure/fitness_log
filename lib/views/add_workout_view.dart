import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout.dart';
import '../providers/workout_provider.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../widgets/AppBarTemplate.dart';

/// Formulaire d'ajout/modification workout
class AddWorkoutView extends ConsumerStatefulWidget {
  final Workout? workout; // Si fourni, mode édition

  const AddWorkoutView({super.key, this.workout});

  @override
  ConsumerState<AddWorkoutView> createState() => _AddWorkoutViewState();
}

class _AddWorkoutViewState extends ConsumerState<AddWorkoutView> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedTypeSport;
  late TextEditingController _dureeController;
  late TextEditingController _caloriesController;
  late TextEditingController _notesController;
  late DateTime _selectedDate;

  String getTypeSport() => _selectedTypeSport;

  @override
  void initState() {
    super.initState();
    final workout = widget.workout;
    _selectedTypeSport = workout?.typeSport ?? AppConstants.sportTypes.last;
    _dureeController = TextEditingController(
      text: workout?.duree.toString() ?? '',
    );
    _caloriesController = TextEditingController(
      text: workout?.caloriesBrulees.toString() ?? '',
    );
    _notesController = TextEditingController(text: workout?.notes ?? '');
    _selectedDate = workout?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _dureeController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.workout != null;

    return Scaffold(
      appBar: AppBartemplate(
          title: isEditing ? 'Modifier la séance' : 'Ajouter une séance'
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Sélecteur de type de sport
            DropdownButtonFormField<String>(
              initialValue: _selectedTypeSport,
              decoration: const InputDecoration(
                labelText: 'Type de sport *',
                border: OutlineInputBorder(),
              ),
              items: AppConstants.sportTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,

                  child:
                  Card(
                    elevation: 4,
                    child: SizedBox.square(
                      dimension: 200,
                      child: Row(
                        children: [
                          Icon(AppConstants.sportIcons.containsKey(type)
                              ? AppConstants.sportIcons[type]
                              : Icons.sports_baseball),
                          Text(type)
                        ],



                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedTypeSport = value;
                    // Suggérer des calories basées sur le type
                    if (_caloriesController.text.isEmpty) {
                      final defaultCalories =
                          AppConstants.defaultCaloriesPerMinute[value] ?? 20;
                      final duree = int.tryParse(_dureeController.text) ?? 30;
                      _caloriesController.text = (defaultCalories * duree)
                          .toString();
                    }
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez sélectionner un type de sport';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Champ durée
            TextFormField(
              controller: _dureeController,
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.timer,
                  color: AppColors.getSportColor(_selectedTypeSport),
                  size: 40,
                ),
                labelText: 'Durée (minutes) *',
                border: OutlineInputBorder(),
                helperText: 'Durée de la séance en minutes',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer une durée';
                }
                final duree = int.tryParse(value);
                if (duree == null || duree <= 0) {
                  return 'Veuillez entrer une durée valide';
                }
                return null;
              },
              onChanged: (value) {
                // Calculer automatiquement les calories si possible
                final duree = int.tryParse(value);
                if (duree != null && _caloriesController.text.isEmpty) {
                  final defaultCalories =
                      AppConstants
                          .defaultCaloriesPerMinute[_selectedTypeSport] ??
                      5;
                  _caloriesController.text = (defaultCalories * duree)
                      .toString();
                }
              },
            ),
            const SizedBox(height: 16),
            // Champ calories
            TextFormField(
              controller: _caloriesController,
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.local_fire_department,
                  color: AppColors.getSportColor(_selectedTypeSport),
                  size: 40,
                ),
                labelText: 'Calories brûlées *',
                border: const OutlineInputBorder(),
                helperText: 'Estimation des calories brûlées',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nombre de calories';
                }
                final calories = int.tryParse(value);
                if (calories == null || calories <= 0) {
                  return 'Veuillez entrer un nombre de calories valide';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Date picker
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date *',
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    ),
                    Icon(
                      Icons.calendar_today,
                      color: AppColors.getSportColor(_selectedTypeSport),
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Champ notes (optionnel)
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notes (optionnel)',
                border: const OutlineInputBorder(),
                helperText: 'Ajoutez des notes sur votre séance',
                helperStyle: TextStyle(
                  color: AppColors.getSportColor(_selectedTypeSport),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            // Boutons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveWorkout,
                    child: Text(isEditing ? 'Enregistrer' : 'Ajouter'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveWorkout() {
    if (_formKey.currentState!.validate()) {
      final workout = Workout(
        id: widget.workout?.id,
        typeSport: _selectedTypeSport,
        duree: int.parse(_dureeController.text),
        caloriesBrulees: int.parse(_caloriesController.text),
        date: _selectedDate,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      if (widget.workout != null) {
        // Mode édition
        ref.read(updateWorkoutProvider.notifier).updateWorkout(workout);
      } else {
        // Mode ajout
        ref.read(addWorkoutProvider.notifier).addWorkout(workout);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.workout != null ? 'Séance modifiée' : 'Séance ajoutée',
          ),
        ),
      );
    }
  }
}
