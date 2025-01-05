import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_event.dart';

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
  String _difficulty = '';
  String _progress = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Rutina'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Objetivo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un objetivo';
                  }
                  return null;
                },
                onSaved: (value) {
                  _goal = value!;
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Duración (minutos)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la duración';
                  }
                  return null;
                },
                onSaved: (value) {
                  _duration = int.parse(value!);
                },
              ),
              CheckboxListTile(
                title: const Text('Privada'),
                value: _isPrivate,
                onChanged: (value) {
                  setState(() {
                    _isPrivate = value!;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Dificultad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la dificultad';
                  }
                  return null;
                },
                onSaved: (value) {
                  _difficulty = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Progreso'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el progreso';
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
                child: const Text('Crear'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
