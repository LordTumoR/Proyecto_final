import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_event.dart';

class FilterRoutineForm extends StatefulWidget {
  @override
  _FilterRoutineFormState createState() => _FilterRoutineFormState();
}

class _FilterRoutineFormState extends State<FilterRoutineForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _difficultyController = TextEditingController();

  bool _isPrivate = false;

  @override
  void dispose() {
    _nameController.dispose();
    _goalController.dispose();
    _durationController.dispose();
    _difficultyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear y Filtrar Rutinas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Nombre',
                validatorMessage: 'Por favor ingrese un nombre',
              ),
              _buildTextField(
                controller: _goalController,
                label: 'Objetivo',
                validatorMessage: 'Por favor ingrese un objetivo',
              ),
              _buildTextField(
                controller: _durationController,
                label: 'Duración (minutos)',
                validatorMessage: 'Por favor ingrese la duración',
                keyboardType: TextInputType.number,
              ),
              CheckboxListTile(
                title: const Text('Privada'),
                value: _isPrivate,
                onChanged: (value) {
                  setState(() {
                    _isPrivate = value ?? false;
                  });
                },
              ),
              _buildTextField(
                controller: _difficultyController,
                label: 'Dificultad',
                validatorMessage: 'Por favor ingrese la dificultad',
              ),
              ElevatedButton(
                onPressed: _onFilter,
                child: const Text('Filtrar Rutinas'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String validatorMessage,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: keyboardType);
  }

  void _onFilter() {
    if (_formKey.currentState!.validate()) {
      final routinesBloc = BlocProvider.of<RoutinesBloc>(context);

      routinesBloc.add(
        FetchUserRoutinesEvent(
          filters: {
            if (_nameController.text.isNotEmpty) 'name': _nameController.text,
            if (_goalController.text.isNotEmpty) 'goal': _goalController.text,
            if (_durationController.text.isNotEmpty)
              'duration': int.tryParse(_durationController.text),
            if (_difficultyController.text.isNotEmpty)
              'difficulty': _difficultyController.text,
            'isPrivate': _isPrivate,
          },
        ),
      );
      Navigator.of(context).pop();
    }
  }
}
