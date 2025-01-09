import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_event.dart';

class EditRoutineDialog extends StatefulWidget {
  final int routineId;

  EditRoutineDialog(this.routineId);

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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nombre de la rutina'),
          ),
          TextField(
            controller: _goalController,
            decoration:
                const InputDecoration(labelText: 'Objetivo de la rutina'),
          ),
          TextField(
            controller: _durationController,
            decoration: const InputDecoration(labelText: 'Duración'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _difficultyController,
            decoration: const InputDecoration(labelText: 'Dificultad'),
          ),
          TextField(
            controller: _progressController,
            decoration: const InputDecoration(labelText: 'Progreso'),
          ),
          SwitchListTile(
            title: const Text('Privada'),
            value: _isPrivate,
            onChanged: (bool value) {
              setState(() {
                _isPrivate = value;
              });
            },
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
            String name = _nameController.text.trim();
            String goal = _goalController.text.trim();
            int duration = int.tryParse(_durationController.text.trim()) ?? 0;
            String difficulty = _difficultyController.text.trim();
            String progress = _progressController.text.trim();
            int routineId = widget.routineId;

            context.read<RoutinesBloc>().add(CreateRoutineEvent(
                  name: name,
                  goal: goal,
                  duration: duration,
                  isPrivate: _isPrivate,
                  difficulty: difficulty,
                  progress: progress,
                  routineId: routineId,
                ));

            Navigator.of(context).pop();
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
