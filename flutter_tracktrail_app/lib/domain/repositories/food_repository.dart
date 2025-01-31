import 'package:flutter_tracktrail_app/domain/entities/food_entity.dart';

abstract class FoodDatabaseRepository {
  Future<List<FoodEntityDatabase>> getNutritionFoods(int dietId);
  Future<FoodEntityDatabase> createFood(FoodEntityDatabase food, int dietId);
  Future<FoodEntityDatabase> updateFood(FoodEntityDatabase food);
}
