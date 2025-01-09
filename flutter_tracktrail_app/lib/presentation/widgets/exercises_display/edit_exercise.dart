import 'package:flutter/material.dart';
import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';

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
      title: const Text('Editar Ejercicio'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre del ejercicio',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descripción del ejercicio',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
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
                const SnackBar(
                    content: Text('Por favor, complete todos los campos.')),
              );
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
