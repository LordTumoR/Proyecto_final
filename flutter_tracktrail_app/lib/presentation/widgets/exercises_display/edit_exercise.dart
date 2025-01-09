import 'package:flutter/material.dart';

class EditExerciseDialog extends StatefulWidget {
  @override
  _EditExerciseDialogState createState() => _EditExerciseDialogState();
}

class _EditExerciseDialogState extends State<EditExerciseDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

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
            Navigator.of(context).pop();
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
