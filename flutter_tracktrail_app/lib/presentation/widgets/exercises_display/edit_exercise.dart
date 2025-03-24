import 'package:flutter/material.dart';
import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/date_manager.dart';

class EditExerciseDialog extends StatefulWidget {
  final ExerciseEntity exercise;
  final Function(ExerciseEntity) onEdit;

  EditExerciseDialog({required this.exercise, required this.onEdit});

  @override
  _EditExerciseDialogState createState() => _EditExerciseDialogState();
}

class _EditExerciseDialogState extends State<EditExerciseDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
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
  void initState() {
    super.initState();
    _nameController.text = widget.exercise.name!;
    _descriptionController.text = widget.exercise.description!;
    _weightController.text = widget.exercise.weight.toString();
    _repetitionsController.text = widget.exercise.repetitions.toString();
    _setsController.text = widget.exercise.sets.toString();
    selectedMuscleGroup = widget.exercise.muscleGroup;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.edit_exercise,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(height: 20),
            _buildTextField(_nameController,
                AppLocalizations.of(context)!.exercise_name, false),
            _buildTextField(_descriptionController,
                AppLocalizations.of(context)!.exercise_description, false),
            _buildTextField(_weightController,
                AppLocalizations.of(context)!.exercise_weight, true),
            _buildTextField(_repetitionsController,
                AppLocalizations.of(context)!.exercise_repetitions, true),
            _buildTextField(_setsController,
                AppLocalizations.of(context)!.exercise_sets, true),
            DropdownButtonFormField<String>(
              value: selectedMuscleGroup,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.exercise_muscleGroup,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
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
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String exerciseName = _nameController.text.trim();
                String exerciseDescription = _descriptionController.text.trim();

                if (exerciseName.isNotEmpty && exerciseDescription.isNotEmpty) {
                  final updatedExercise = ExerciseEntity(
                    id: widget.exercise.id,
                    name: exerciseName,
                    description: exerciseDescription,
                    dateTime: fechaSeleccionada,
                    image: widget.exercise.image,
                    weight: double.tryParse(_weightController.text) ?? 0,
                    repetitions: int.tryParse(_repetitionsController.text) ?? 0,
                    sets: int.tryParse(_setsController.text) ?? 0,
                    muscleGroup:
                        selectedMuscleGroup ?? widget.exercise.muscleGroup,
                  );

                  widget.onEdit(updatedExercise);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            AppLocalizations.of(context)!.error_fields_empty)),
                  );
                }
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, bool isNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      ),
    );
  }
}
