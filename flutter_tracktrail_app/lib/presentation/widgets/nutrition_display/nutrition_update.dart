import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/nutrition/nutrition_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/nutrition/nutrition_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/nutrition/nutrition_state.dart';

class EditNutritionRecordDialog extends StatefulWidget {
  final int id;
  final String initialName;
  final String initialDescription;

  const EditNutritionRecordDialog({
    Key? key,
    required this.id,
    required this.initialName,
    required this.initialDescription,
  }) : super(key: key);

  @override
  _EditNutritionRecordDialogState createState() =>
      _EditNutritionRecordDialogState();
}

class _EditNutritionRecordDialogState extends State<EditNutritionRecordDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.initialName;
    _descriptionController.text = widget.initialDescription;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Editar Registro Nutricional',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(_nameController, 'Nombre de la dieta'),
            _buildTextField(_descriptionController, 'Descripción'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text;
                final description = _descriptionController.text;
                final date =
                    DateTime.tryParse(_dateController.text) ?? DateTime.now();

                context.read<NutritionBloc>().add(
                      UpdateNutritionRecord(
                        id: widget.id,
                        name: name,
                        description: description,
                        date: date,
                        userId: 0,
                      ),
                    );

                Navigator.pop(context);
              },
              child: const Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
