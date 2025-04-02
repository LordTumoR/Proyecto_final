import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/domain/entities/food_entity.dart';
import 'package:flutter_tracktrail_app/domain/entities/openfoodfacts_entity.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_state.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_event.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/date_manager.dart';

class SearchFoodsTab extends StatefulWidget {
  final int dietId;

  const SearchFoodsTab({required this.dietId, super.key});
  @override
  _SearchFoodsTabState createState() => _SearchFoodsTabState();
}

class _SearchFoodsTabState extends State<SearchFoodsTab> {
  String selectedMealType = 'Desayuno';
  @override
  void initState() {
    super.initState();
    context.read<FoodBloc>().add(LoadRandomFoods());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodBloc, FoodState>(
      builder: (context, state) {
        if (state is FoodLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FoodError) {
          return const Center(
            child: Text(
              'Error al cargar los alimentos',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        } else if (state is FoodLoaded) {
          final foodList = state.foodList;

          return ListView.builder(
            itemCount: foodList.length,
            itemBuilder: (context, index) {
              final foodItem = foodList[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  title: Row(
                    children: [
                      if (foodItem.imageUrl != null &&
                          foodItem.imageUrl!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.network(
                              foodItem.imageUrl!,
                              width: 120,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              foodItem.name ?? 'Nombre no disponible',
                              style: const TextStyle(
                                color: Colors.brown,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              'Marca: ${foodItem.brand ?? 'Desconocido'}',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Categoría: ${foodItem.category ?? 'Desconocida'}',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Calorías: ${foodItem.nutritionInfo?.toStringAsFixed(2) ?? 'N/A'} kcal',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      _addFoodItem(foodItem);
                    },
                  ),
                ),
              );
            },
          );
        }

        return const Center(child: Text('No hay alimentos disponibles'));
      },
    );
  }

  void _addFoodItem(FoodEntity foodItem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Añadir alimento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('¿Deseas añadir ${foodItem.name} a tu lista?'),
              DropdownButtonFormField<String>(
                value: 'Desayuno',
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
            ],
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
                final fechaSeleccionada = DateManager().selectedDate.value;

                final foodEntity = FoodEntityDatabase(
                  id: 0,
                  name: foodItem.name ?? '',
                  brand: foodItem.brand ?? '',
                  category: foodItem.category ?? '',
                  calories: foodItem.nutritionInfo,
                  carbohydrates: 0,
                  protein: 0,
                  fat: 0,
                  fiber: 0,
                  sugar: 0,
                  sodium: 0,
                  cholesterol: 0,
                  mealtype: selectedMealType,
                  date: fechaSeleccionada,
                );

                context.read<FoodBloc>().add(CreateFoodEvent(
                      foodEntity,
                      widget.dietId,
                      loadRandomFoods: false,
                    ));

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${foodItem.name} añadido correctamente'),
                  ),
                );
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }
}
