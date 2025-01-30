import 'package:flutter/material.dart';
import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/date_manager.dart';

class CreateExerciseDrawer extends StatelessWidget {
  final int routineId;
  final Function(ExerciseEntity) onCreate;
  final fechaSeleccionada = DateManager().selectedDate.value;

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
            Text(
              AppLocalizations.of(context)!.create_exercise,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.exercise_name),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.error_exercise_name;
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.exercise_description),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!
                      .error_exercise_description;
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
                    dateTime: fechaSeleccionada,
                  );
                  onCreate(newExercise);
                  Navigator.pop(context);
                }
              },
              child: Text(AppLocalizations.of(context)!.create_exercise_button),
            ),
          ],
        ),
      ),
    );
  }
}
