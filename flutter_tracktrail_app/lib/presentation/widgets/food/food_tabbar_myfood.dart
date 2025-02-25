import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/domain/entities/food_entity.dart';
import 'package:flutter_tracktrail_app/domain/entities/openfoodfacts_entity.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_state.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/food/edit_food_dialog.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/date_manager.dart';

class DatabaseFoodsTab extends StatefulWidget {
  final int dietId;

  const DatabaseFoodsTab({required this.dietId, super.key});

  @override
  _DatabaseFoodsTabState createState() => _DatabaseFoodsTabState();
}

class _DatabaseFoodsTabState extends State<DatabaseFoodsTab> {
  final DatePickerController _controller = DatePickerController();
  @override
  void initState() {
    super.initState();
    final fechaSeleccionada = DateManager().selectedDate.value;
    context.read<FoodBloc>().add(
          LoadDatabaseFoods(
            dietId: widget.dietId,
            name: null,
            minCalories: null,
            maxCalories: null,
            category: null,
            brand: null,
          ),
        );

    DateManager().selectedDate.addListener(() {
      final nuevaFecha = DateManager().selectedDate.value;
      context.read<FoodBloc>().add(
            LoadDatabaseFoods(
              dietId: widget.dietId,
              name: null,
              minCalories: null,
              maxCalories: null,
              category: null,
              brand: null,
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = context.watch<DateManager>().selectedDate;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro de Alimentos"),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: 100,
              child: DatePicker(
                DateTime.now(),
                controller: _controller,
                initialSelectedDate: selectedDate.value,
                onDateChange: (date) {
                  context.read<DateManager>().updateDate(date);
                },
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<FoodBloc, FoodState>(
              builder: (context, state) {
                if (state is FoodLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FoodError) {
                  return Center(
                    child: Text(
                      'Error al cargar los alimentos: ${state.errorMessage}',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                } else if (state is FoodDatabaseLoaded) {
                  final filteredFoodList = state.foodList
                      .where((food) => food == selectedDate)
                      .toList();

                  if (filteredFoodList.isEmpty) {
                    return const Center(
                      child: Text('No hay alimentos guardados para esta fecha'),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView.builder(
                      itemCount: filteredFoodList.length,
                      itemBuilder: (context, index) {
                        final foodItem = filteredFoodList[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 227, 248, 41)
                                .withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  foodItem.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Calorías: ${foodItem.calories?.toStringAsFixed(2) ?? 'N/A'} kcal',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Proteínas: ${foodItem.protein?.toStringAsFixed(2) ?? 'N/A'} g',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Carbohidratos: ${foodItem.carbohydrates?.toStringAsFixed(2) ?? 'N/A'} g',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Grasas: ${foodItem.fat?.toStringAsFixed(2) ?? 'N/A'} g',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.more,
                                      color: Color.fromARGB(255, 45, 18, 143)),
                                  onPressed: () {
                                    _showFoodDetailsDialog(context, foodItem);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Color.fromARGB(255, 45, 18, 143)),
                                  onPressed: () {
                                    _showEditFoodDialog(context, foodItem);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                return const Center(
                    child: Text('No hay alimentos disponibles'));
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditFoodDialog(BuildContext context, FoodEntityDatabase foodItem) {
    showDialog(
      context: context,
      builder: (context) {
        return EditFoodDialog(
          food: foodItem,
          dietId: widget.dietId,
        );
      },
    );
  }

  void _showFoodDetailsDialog(
      BuildContext context, FoodEntityDatabase foodItem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(foodItem.name),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Calorías: ${foodItem.calories?.toStringAsFixed(2) ?? 'N/A'} kcal'),
                Text(
                    'Proteínas: ${foodItem.protein?.toStringAsFixed(2) ?? 'N/A'} g'),
                Text(
                    'Carbohidratos: ${foodItem.carbohydrates?.toStringAsFixed(2) ?? 'N/A'} g'),
                Text('Grasas: ${foodItem.fat?.toStringAsFixed(2) ?? 'N/A'} g'),
                Text('Fibra: ${foodItem.fiber?.toStringAsFixed(2) ?? 'N/A'} g'),
                Text(
                    'Azúcar: ${foodItem.sugar?.toStringAsFixed(2) ?? 'N/A'} g'),
                Text(
                    'Sodio: ${foodItem.sodium?.toStringAsFixed(2) ?? 'N/A'} mg'),
                Text(
                    'Colesterol: ${foodItem.cholesterol?.toStringAsFixed(2) ?? 'N/A'} mg'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
