import 'package:flutter_tracktrail_app/data/datasources/food_datasource.dart';
import 'package:flutter_tracktrail_app/data/models/food_model.dart';
import 'package:flutter_tracktrail_app/domain/entities/food_entity.dart';
import 'package:flutter_tracktrail_app/domain/repositories/food_repository.dart';

class FoodDatabaseRepositoryImpl implements FoodDatabaseRepository {
  final FoodDatabaseRemoteDataSource remoteDataSource;

  FoodDatabaseRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<FoodEntityDatabase>> getNutritionFoods(int dietId) async {
    try {
      final foodModels = await remoteDataSource.getNutritionFoods(dietId);
      return foodModels.map((foodModel) => foodModel.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al obtener los alimentos: $e');
    }
  }

  @override
  Future<FoodEntityDatabase> createFood(
      FoodEntityDatabase food, int dietId) async {
    try {
      final foodModel = FoodModelDatabase(
        id: food.id,
        name: food.name,
        brand: food.brand,
        category: food.category,
        calories: food.calories,
        carbohydrates: food.carbohydrates,
        protein: food.protein,
        fat: food.fat,
        fiber: food.fiber,
        sugar: food.sugar,
        sodium: food.sodium,
        cholesterol: food.cholesterol,
        mealtype: food.mealtype,
        date: food.date,
      );

      final createdFoodModel =
          await remoteDataSource.createFood(foodModel, dietId);

      return createdFoodModel.toEntity();
    } catch (e) {
      throw Exception('Error al crear el alimento: $e');
    }
  }

  @override
  Future<FoodEntityDatabase> updateFood(FoodEntityDatabase food) async {
    try {
      final foodModel = FoodModelDatabase(
        id: food.id,
        name: food.name,
        brand: food.brand,
        category: food.category,
        calories: food.calories,
        carbohydrates: food.carbohydrates,
        protein: food.protein,
        fat: food.fat,
        fiber: food.fiber,
        sugar: food.sugar,
        sodium: food.sodium,
        cholesterol: food.cholesterol,
        mealtype: food.mealtype,
        date: food.date,
      );

      final updatedFood = await remoteDataSource.updateFood(foodModel);

      return updatedFood.toEntity();
    } catch (e) {
      throw Exception('Error al crear el alimento: $e');
    }
  }
}
