import 'package:flutter/material.dart';

class EditRoutineDialog extends StatefulWidget {
  @override
  _EditRoutineDialogState createState() => _EditRoutineDialogState();
}

class _EditRoutineDialogState extends State<EditRoutineDialog> {
  final _nameController = TextEditingController();
  final _goalController = TextEditingController();
  final _durationController = TextEditingController();
  final _difficultyController = TextEditingController();
  final _progressController = TextEditingController();

  bool _isPrivate = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Rutina'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nuevo nombre de la rutina',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _goalController,
              decoration: const InputDecoration(
                labelText: 'Objetivo de la rutina',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Duración (minutos)',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _difficultyController,
              decoration: const InputDecoration(
                labelText: 'Dificultad',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _progressController,
              decoration: const InputDecoration(
                labelText: 'Progreso',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Privada'),
                Switch(
                  value: _isPrivate,
                  onChanged: (bool value) {
                    setState(() {
                      _isPrivate = value;
                    });
                  },
                ),
                const Text('Pública'),
              ],
            ),
          ],
        ),
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
            String newName = _nameController.text.trim();
            String goal = _goalController.text.trim();
            String duration = _durationController.text.trim();
            String difficulty = _difficultyController.text.trim();
            String progress = _progressController.text.trim();
            bool isPrivate = _isPrivate;

            if (newName.isNotEmpty &&
                goal.isNotEmpty &&
                duration.isNotEmpty &&
                difficulty.isNotEmpty &&
                progress.isNotEmpty) {}

            Navigator.of(context).pop();
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
