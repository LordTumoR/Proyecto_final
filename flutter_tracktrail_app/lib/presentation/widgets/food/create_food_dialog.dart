import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/data/datasources/openai_service.dart';
import 'package:flutter_tracktrail_app/domain/entities/food_entity.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_event.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/date_manager.dart';
import 'package:image_picker/image_picker.dart';

class CreateFoodDialog extends StatefulWidget {
  final int dietId;
  const CreateFoodDialog({
    Key? key,
    required this.dietId,
  }) : super(key: key);

  @override
  _CreateFoodDialogState createState() => _CreateFoodDialogState();
}

class _CreateFoodDialogState extends State<CreateFoodDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _categoryController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _carbohydratesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _fatController = TextEditingController();
  final _fiberController = TextEditingController();
  final _sugarController = TextEditingController();
  final _sodiumController = TextEditingController();
  final _cholesterolController = TextEditingController();
  final fechaSeleccionada = DateManager().selectedDate.value;

  bool _showFullForm = false;
  String selectedMealType = 'Desayuno';
  final OpenAIService openAIService = OpenAIService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Crear Alimento'),
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
              // Dropdown for meal type
              DropdownButtonFormField<String>(
                value: selectedMealType,
                items: ['Desayuno', 'Comida', 'Merienda', 'Cena']
                    .map((meal) => DropdownMenuItem<String>(
                          value: meal,
                          child: Text(meal),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedMealType = value;
                    });
                  }
                },
                decoration: const InputDecoration(labelText: 'Tipo de Comida'),
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
              final foodEntity = FoodEntityDatabase(
                id: 0,
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
                mealtype: selectedMealType,
                date: fechaSeleccionada,
              );

              context.read<FoodBloc>().add(CreateFoodEvent(
                    foodEntity,
                    widget.dietId,
                    loadRandomFoods: false,
                  ));

              Navigator.of(context).pop();
            }
          },
          child: const Text('Crear'),
        ),
        ElevatedButton(
          onPressed: () async {
            // Mostrar un diálogo de advertencia
            bool? confirm = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Atención'),
                  content: const Text(
                    'El valor seleccionado de MEALTYPE afectará a la automatización de los alimentos. ¿Estás seguro de continuar?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Aceptar'),
                    ),
                  ],
                );
              },
            );

            if (confirm != true) return;

            final ImagePicker picker = ImagePicker();
            final XFile? image =
                await picker.pickImage(source: ImageSource.gallery);

            if (image != null) {
              final file = File(image.path);

              try {
                final List<FoodEntityDatabase> alimentos =
                    await openAIService.analizarImagenYGuardarAlimentos(file);

                for (var comida in alimentos) {
                  comida.mealtype = selectedMealType;

                  context.read<FoodBloc>().add(CreateFoodEvent(
                        comida,
                        widget.dietId,
                        loadRandomFoods: false,
                      ));
                }

                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Error al analizar la imagen")),
                );
              }
            }
          },
          child: const Text('Subir imagen'),
        )
      ],
    );
  }
}
