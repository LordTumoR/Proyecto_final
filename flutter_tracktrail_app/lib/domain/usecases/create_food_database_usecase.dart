import 'package:flutter_tracktrail_app/domain/entities/food_entity.dart';
import 'package:flutter_tracktrail_app/domain/repositories/food_repository.dart';

class CreateFood {
  final FoodDatabaseRepository repository;

  CreateFood(this.repository);

  Future<FoodEntityDatabase> call(FoodEntityDatabase food, int dietId) async {
    return await repository.createFood(food, dietId);
  }
}
