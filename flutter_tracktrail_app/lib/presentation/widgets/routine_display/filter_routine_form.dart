// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  bool _isPrivate = false;
  String _difficulty = '';

  @override
  void dispose() {
    _nameController.dispose();
    _goalController.dispose();
    _durationController.dispose();
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
                label: AppLocalizations.of(context)!.name,
              ),
              _buildTextField(
                controller: _goalController,
                label: AppLocalizations.of(context)!.goal,
              ),
              _buildTextField(
                controller: _durationController,
                label: AppLocalizations.of(context)!.duration,
                keyboardType: TextInputType.number,
              ),
              CheckboxListTile(
                title: Text(AppLocalizations.of(context)!.private),
                value: _isPrivate,
                onChanged: (value) {
                  setState(() {
                    _isPrivate = value ?? false;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.difficulty),
                value: _difficulty.isEmpty ? null : _difficulty,
                items: const [
                  DropdownMenuItem(value: 'Easy', child: Text('Easy')),
                  DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'Hard', child: Text('Hard')),
                ],
                onChanged: (value) {
                  setState(() {
                    _difficulty = value ?? '';
                  });
                },
                onSaved: (value) {
                  _difficulty = value ?? '';
                },
              ),
              ElevatedButton(
                onPressed: _onFilter,
                child: Text(AppLocalizations.of(context)!.filter_routines),
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
    );
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
            if (_difficulty.isNotEmpty) 'difficulty': _difficulty,
            'isPrivate': _isPrivate,
          },
        ),
      );
      Navigator.of(context).pop();
    }
  }
}
