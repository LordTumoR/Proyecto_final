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
  String _difficulty = 'Easy';
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
                decoration: const InputDecoration(labelText: 'Duración (Dias)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la duración';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingrese un número válido';
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
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Dificultad'),
                value: _difficulty,
                items: const [
                  DropdownMenuItem(value: 'Easy', child: Text('Easy')),
                  DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'Hard', child: Text('Hard')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione una dificultad';
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
