import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/domain/entities/food_entity.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_event.dart';

class EditFoodDialog extends StatefulWidget {
  final FoodEntityDatabase food;
  final int dietId;

  const EditFoodDialog({
    Key? key,
    required this.food,
    required this.dietId,
  }) : super(key: key);

  @override
  _EditFoodDialogState createState() => _EditFoodDialogState();
}

class _EditFoodDialogState extends State<EditFoodDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _brandController;
  late final TextEditingController _categoryController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _carbohydratesController;
  late final TextEditingController _proteinController;
  late final TextEditingController _fatController;
  late final TextEditingController _fiberController;
  late final TextEditingController _sugarController;
  late final TextEditingController _sodiumController;
  late final TextEditingController _cholesterolController;

  bool _showFullForm = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.food.name);
    _brandController = TextEditingController(text: widget.food.brand);
    _categoryController = TextEditingController(text: widget.food.category);
    _caloriesController = TextEditingController(
        text: widget.food.calories?.toStringAsFixed(2) ?? '');
    _carbohydratesController = TextEditingController(
        text: widget.food.carbohydrates?.toStringAsFixed(2) ?? '');
    _proteinController = TextEditingController(
        text: widget.food.protein?.toStringAsFixed(2) ?? '');
    _fatController =
        TextEditingController(text: widget.food.fat?.toStringAsFixed(2) ?? '');
    _fiberController = TextEditingController(
        text: widget.food.fiber?.toStringAsFixed(2) ?? '');
    _sugarController = TextEditingController(
        text: widget.food.sugar?.toStringAsFixed(2) ?? '');
    _sodiumController = TextEditingController(
        text: widget.food.sodium?.toStringAsFixed(2) ?? '');
    _cholesterolController = TextEditingController(
        text: widget.food.cholesterol?.toStringAsFixed(2) ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Alimento'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Marca'),
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(labelText: 'Calorías'),
                keyboardType: TextInputType.number,
              ),
              if (!_showFullForm)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showFullForm = true;
                    });
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Modo completo'),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              if (_showFullForm) ...[
                TextFormField(
                  controller: _carbohydratesController,
                  decoration: const InputDecoration(labelText: 'Carbohidratos'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _proteinController,
                  decoration: const InputDecoration(labelText: 'Proteínas'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _fatController,
                  decoration: const InputDecoration(labelText: 'Grasas'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _fiberController,
                  decoration: const InputDecoration(labelText: 'Fibra'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _sugarController,
                  decoration: const InputDecoration(labelText: 'Azúcar'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _sodiumController,
                  decoration: const InputDecoration(labelText: 'Sodio'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _cholesterolController,
                  decoration: const InputDecoration(labelText: 'Colesterol'),
                  keyboardType: TextInputType.number,
                ),
              ],
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
              final updatedFood = FoodEntityDatabase(
                id: widget.food.id,
                name: _nameController.text,
                brand: _brandController.text,
                category: _categoryController.text,
                calories: double.tryParse(_caloriesController.text),
                carbohydrates: double.tryParse(_carbohydratesController.text),
                protein: double.tryParse(_proteinController.text),
                fat: double.tryParse(_fatController.text),
                fiber: double.tryParse(_fiberController.text),
                sugar: double.tryParse(_sugarController.text),
                sodium: double.tryParse(_sodiumController.text),
                cholesterol: double.tryParse(_cholesterolController.text),
              );

              context
                  .read<FoodBloc>()
                  .add(UpdateFoodEvent(updatedFood, widget.dietId));

              Navigator.of(context).pop();
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
