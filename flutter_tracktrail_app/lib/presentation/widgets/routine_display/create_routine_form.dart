import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateRoutineForm extends StatefulWidget {
  @override
  _CreateRoutineFormState createState() => _CreateRoutineFormState();
}

class _CreateRoutineFormState extends State<CreateRoutineForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _goal = '';
  int _duration = 0;
  bool _isPrivate = false;
  String _difficulty = 'Easy';
  String _progress = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.create_routine),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.name),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.name_required;
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.goal),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.goal_required;
                  }
                  return null;
                },
                onSaved: (value) {
                  _goal = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.duration),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.duration_required;
                  }
                  if (int.tryParse(value) == null) {
                    return AppLocalizations.of(context)!.valid_number;
                  }
                  return null;
                },
                onSaved: (value) {
                  _duration = int.parse(value!);
                },
              ),
              CheckboxListTile(
                title: Text(AppLocalizations.of(context)!.private),
                value: _isPrivate,
                onChanged: (value) {
                  setState(() {
                    _isPrivate = value!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.difficulty),
                value: _difficulty,
                items: const [
                  DropdownMenuItem(value: 'Easy', child: Text('Easy')),
                  DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'Hard', child: Text('Hard')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.select_difficulty;
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _difficulty = value!;
                  });
                },
                onSaved: (value) {
                  _difficulty = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.progress),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.progress_required;
                  }
                  return null;
                },
                onSaved: (value) {
                  _progress = value!;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    BlocProvider.of<RoutinesBloc>(context).add(
                      CreateRoutineEvent(
                        name: _name,
                        goal: _goal,
                        duration: _duration,
                        isPrivate: _isPrivate,
                        difficulty: _difficulty,
                        progress: _progress,
                      ),
                    );

                    BlocProvider.of<RoutinesBloc>(context)
                        .add(FetchRoutinesEvent());

                    Navigator.of(context).pop();
                  }
                },
                child: Text(AppLocalizations.of(context)!.create),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
