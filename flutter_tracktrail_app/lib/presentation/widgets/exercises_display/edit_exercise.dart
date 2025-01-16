import 'package:flutter/material.dart';
import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.exercise.name!;
    _descriptionController.text = widget.exercise.description!;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.edit_exercise),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.exercise_name,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.exercise_description,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () {
            String exerciseName = _nameController.text.trim();
            String exerciseDescription = _descriptionController.text.trim();

            if (exerciseName.isNotEmpty && exerciseDescription.isNotEmpty) {
              final updatedExercise = ExerciseEntity(
                id: widget.exercise.id,
                name: exerciseName,
                description: exerciseDescription,
                image: widget.exercise.image,
              );

              widget.onEdit(updatedExercise);
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text(AppLocalizations.of(context)!.error_fields_empty)),
              );
            }
          },
          child: Text(AppLocalizations.of(context)!.save),
        ),
      ],
    );
  }
}
