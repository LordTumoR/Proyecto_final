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
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DatabaseFoodsTab extends StatefulWidget {
  final int dietId;
  final bool isUserDiet;

  const DatabaseFoodsTab(
      {required this.dietId, required this.isUserDiet, super.key});

  @override
  _DatabaseFoodsTabState createState() => _DatabaseFoodsTabState();
}

class _DatabaseFoodsTabState extends State<DatabaseFoodsTab> {
  final DatePickerController _controller = DatePickerController();
  String selectedMealType = 'Desayuno';
  final ImagePicker _picker = ImagePicker();
  Map<int, File?> _foodImages = {};

  @override
  void initState() {
    super.initState();
    _loadFoods();

    DateManager().selectedDate.addListener(() {
      _loadFoods();
    });
  }

  void _loadFoods() {
    final fechaSeleccionada = DateManager().selectedDate.value;
    context.read<FoodBloc>().add(
          LoadDatabaseFoods(
            dietId: widget.dietId,
            name: null,
            minCalories: null,
            maxCalories: null,
            category: null,
            brand: null,
            mealType: selectedMealType,
          ),
        );
  }

  Future<void> _pickImage(FoodEntityDatabase foodItem) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _foodImages[foodItem.id] = File(pickedFile.path);
      });

      final updatedFood = FoodEntityDatabase(
        id: foodItem.id,
        name: foodItem.name,
        brand: foodItem.brand,
        category: foodItem.category,
        date: foodItem.date,
        calories: foodItem.calories,
        protein: foodItem.protein,
        carbohydrates: foodItem.carbohydrates,
        fat: foodItem.fat,
        fiber: foodItem.fiber,
        sugar: foodItem.sugar,
        sodium: foodItem.sodium,
        cholesterol: foodItem.cholesterol,
        mealtype: foodItem.mealtype,
        imageUrl: _foodImages[foodItem.id]?.path,
      );
      print('Picked file path: ${pickedFile.path}');

      context.read<FoodBloc>().add(UpdateFoodEvent(updatedFood, widget.dietId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = context.watch<DateManager>().selectedDate;

    return Scaffold(
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      ['Desayuno', 'Comida', 'Merienda', 'Cena'].map((meal) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMealType = meal;
                          _loadFoods();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedMealType == meal
                              ? Colors.blueAccent
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selectedMealType == meal
                                ? Colors.blue
                                : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          meal,
                          style: TextStyle(
                            color: selectedMealType == meal
                                ? Colors.white
                                : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
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
                  final selectedDateString =
                      DateFormat('yyyy-MM-dd').format(selectedDate.value);

                  final filteredFoodList = state.foodList.where((food) {
                    final foodDateString =
                        DateFormat('yyyy-MM-dd').format(food.date!.toLocal());
                    return foodDateString == selectedDateString &&
                        food.mealtype == selectedMealType;
                  }).toList();

                  if (filteredFoodList.isEmpty) {
                    return const Center(
                      child: Text(
                          'No hay alimentos guardados para esta selección'),
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
                            leading: Stack(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey[200],
                                    image: foodItem.imageUrl != null &&
                                            foodItem.imageUrl!.isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                foodItem.imageUrl!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: foodItem.imageUrl == null ||
                                          foodItem.imageUrl!.isEmpty
                                      ? const Icon(Icons.fastfood, size: 30)
                                      : null,
                                ),
                                if (widget.isUserDiet)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () => _pickImage(foodItem),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
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
                                  'Marca: ${foodItem.brand} ',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Categoria: ${foodItem.category} ',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Carbohidratos: ${foodItem.carbohydrates} ',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            trailing: widget.isUserDiet
                                ? IconButton(
                                    icon: const Icon(Icons.edit,
                                        color:
                                            Color.fromARGB(255, 45, 18, 143)),
                                    onPressed: () {
                                      _showEditFoodDialog(context, foodItem);
                                    },
                                  )
                                : null,
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
                if (foodItem.imageUrl != null && foodItem.imageUrl!.isNotEmpty)
                  Image.network(foodItem.imageUrl!),
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
