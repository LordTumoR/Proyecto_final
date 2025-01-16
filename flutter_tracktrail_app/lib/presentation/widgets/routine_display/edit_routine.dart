import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      title: Text(AppLocalizations.of(context)!.edit_routine),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration:
                InputDecoration(labelText: AppLocalizations.of(context)!.name),
          ),
          TextField(
            controller: _goalController,
            decoration:
                InputDecoration(labelText: AppLocalizations.of(context)!.goal),
          ),
          TextField(
            controller: _durationController,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.duration),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _difficultyController,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.difficulty),
          ),
          TextField(
            controller: _progressController,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.progress),
          ),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.private),
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
          child: Text(AppLocalizations.of(context)!.cancel),
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
          child: Text(AppLocalizations.of(context)!.save),
        ),
      ],
    );
  }
}
