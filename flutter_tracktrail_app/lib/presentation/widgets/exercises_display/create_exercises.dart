import 'package:flutter/material.dart';
import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/date_manager.dart';

class CreateExerciseDrawer extends StatefulWidget {
  final int routineId;
  final Function(ExerciseEntity) onCreate;

  CreateExerciseDrawer({required this.routineId, required this.onCreate});

  @override
  _CreateExerciseDrawerState createState() => _CreateExerciseDrawerState();
}

class _CreateExerciseDrawerState extends State<CreateExerciseDrawer> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repetitionsController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  final fechaSeleccionada = DateManager().selectedDate.value;

  String? selectedMuscleGroup;

  final List<String> muscleGroups = [
    "Pecho",
    "Espalda",
    "Hombros",
    "Bíceps",
    "Tríceps",
    "Abdominales",
    "Piernas",
    "Glúteos"
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.create_exercise,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.exercise_name),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.error_exercise_name;
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.exercise_description),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!
                      .error_exercise_description;
                }
                return null;
              },
            ),
            TextFormField(
              controller: _weightController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.exercise_weight),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.error_exercise_weight;
                }
                return null;
              },
            ),
            TextFormField(
              controller: _repetitionsController,
              decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.exercise_repetitions),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!
                      .error_exercise_repetitions;
                }
                return null;
              },
            ),
            TextFormField(
              controller: _setsController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.exercise_sets),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.error_exercise_sets;
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: selectedMuscleGroup,
              decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.exercise_muscleGroup),
              items: muscleGroups.map((String group) {
                return DropdownMenuItem<String>(
                  value: group,
                  child: Text(group),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedMuscleGroup = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!
                      .error_exercise_muscleGroup;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newExercise = ExerciseEntity(
                    id: 0,
                    name: _nameController.text,
                    description: _descriptionController.text,
                    image: '',
                    dateTime: fechaSeleccionada,
                    weight: double.tryParse(_weightController.text) ?? 0,
                    repetitions: int.tryParse(_repetitionsController.text) ?? 0,
                    sets: int.tryParse(_setsController.text) ?? 0,
                    muscleGroup: selectedMuscleGroup!,
                  );
                  widget.onCreate(newExercise);
                  Navigator.pop(context);
                }
              },
              child: Text(AppLocalizations.of(context)!.create_exercise_button),
            ),
          ],
        ),
      ),
    );
  }
}
