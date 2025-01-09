import 'package:flutter/material.dart';
import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';

class CreateExerciseDrawer extends StatelessWidget {
  final int routineId;
  final Function(ExerciseEntity) onCreate;

  CreateExerciseDrawer({required this.routineId, required this.onCreate});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Crear nuevo ejercicio',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration:
                  const InputDecoration(labelText: 'Nombre del ejercicio'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el nombre';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese la descripción';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newExercise = ExerciseEntity(
                    id: 0,
                    name: _nameController.text,
                    description: _descriptionController.text,
                    image: '',
                  );
                  onCreate(newExercise);
                  Navigator.pop(context);
                }
              },
              child: const Text('Crear Ejercicio'),
            ),
          ],
        ),
      ),
    );
  }
}
