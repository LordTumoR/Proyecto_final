import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_event.dart';

class FilterFoodDialog extends StatefulWidget {
  final int dietId;

  const FilterFoodDialog({Key? key, required this.dietId}) : super(key: key);

  @override
  _FilterFoodDialogState createState() => _FilterFoodDialogState();
}

class _FilterFoodDialogState extends State<FilterFoodDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _minCaloriesController = TextEditingController();
  final _maxCaloriesController = TextEditingController();
  final _categoryController = TextEditingController();
  final _brandController = TextEditingController();

  bool _isFilterApplied(String? value) => value != null && value.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateState);
    _minCaloriesController.addListener(_updateState);
    _maxCaloriesController.addListener(_updateState);
    _categoryController.addListener(_updateState);
    _brandController.addListener(_updateState);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateState);
    _minCaloriesController.removeListener(_updateState);
    _maxCaloriesController.removeListener(_updateState);
    _categoryController.removeListener(_updateState);
    _brandController.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filtrar Alimentos'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterField(_nameController, 'Nombre'),
              _buildFilterField(_minCaloriesController, 'Calorías mínimas',
                  isNumeric: true),
              _buildFilterField(_maxCaloriesController, 'Calorías máximas',
                  isNumeric: true),
              _buildFilterField(_categoryController, 'Categoría'),
              _buildFilterField(_brandController, 'Marca'),
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
              context.read<FoodBloc>().add(
                    LoadDatabaseFoods(
                      dietId: widget.dietId,
                      name: _nameController.text.isNotEmpty
                          ? _nameController.text
                          : null,
                      minCalories: _minCaloriesController.text.isNotEmpty
                          ? double.tryParse(_minCaloriesController.text)
                          : null,
                      maxCalories: _maxCaloriesController.text.isNotEmpty
                          ? double.tryParse(_maxCaloriesController.text)
                          : null,
                      category: _categoryController.text.isNotEmpty
                          ? _categoryController.text
                          : null,
                      brand: _brandController.text.isNotEmpty
                          ? _brandController.text
                          : null,
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
              _minCaloriesController.clear();
              _maxCaloriesController.clear();
              _categoryController.clear();
              _brandController.clear();
            });
          },
          child: const Text('Borrar Filtros'),
        ),
      ],
    );
  }

  Widget _buildFilterField(TextEditingController controller, String label,
      {bool isNumeric = false}) {
    return Stack(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: _isFilterApplied(controller.text)
                ? const Icon(Icons.circle, color: Colors.red, size: 10)
                : null,
          ),
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        ),
      ],
    );
  }
}
