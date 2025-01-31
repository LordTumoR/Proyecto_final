import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/nutrition/nutrition_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/nutrition/nutrition_event.dart';

class FilterNutritionDialog extends StatefulWidget {
  @override
  _FilterNutritionDialogState createState() => _FilterNutritionDialogState();
}

class _FilterNutritionDialogState extends State<FilterNutritionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();

  bool _isFilterApplied(String? value) => value != null && value.isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filtrar Registros Nutricionales'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterField(_nameController, 'Nombre'),
              _buildFilterField(_descriptionController, 'Descripción'),
              _buildDateField(),
            ],
          ),
        ),
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
            if (_formKey.currentState!.validate()) {
              final name = _nameController.text;
              final description = _descriptionController.text;
              final date = _dateController.text.isNotEmpty
                  ? DateTime.tryParse(_dateController.text)
                  : null;

              context.read<NutritionBloc>().add(
                    FetchNutritionRecords(
                      name: name,
                      description: description,
                      date: date,
                    ),
                  );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Aplicar'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _nameController.clear();
              _descriptionController.clear();
              _dateController.clear();
            });
          },
          child: const Text('Borrar Filtros'),
        ),
      ],
    );
  }

  Widget _buildFilterField(TextEditingController controller, String label,
      {bool isDate = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: _isFilterApplied(controller.text)
            ? const Icon(Icons.circle, color: Colors.red, size: 10)
            : null,
      ),
      keyboardType: isDate ? TextInputType.datetime : TextInputType.text,
      validator: isDate
          ? (value) {
              if (value != null && value.isNotEmpty) {
                final date = DateTime.tryParse(value);
                if (date == null) {
                  return 'Formato de fecha inválido';
                }
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: _dateController,
          decoration: InputDecoration(
            labelText: 'Fecha',
            suffixIcon: _isFilterApplied(_dateController.text)
                ? const Icon(Icons.circle, color: Colors.red, size: 10)
                : null,
          ),
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final date = DateTime.tryParse(value);
              if (date == null) {
                return 'Formato de fecha inválido';
              }
            }
            return null;
          },
        ),
      ),
    );
  }
}
