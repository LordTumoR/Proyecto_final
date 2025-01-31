import 'package:flutter_tracktrail_app/domain/entities/food_entity.dart';
import 'package:flutter_tracktrail_app/domain/repositories/food_repository.dart';

class UpdateFood {
  final FoodDatabaseRepository repository;

  UpdateFood(this.repository);

  Future<FoodEntityDatabase> call(FoodEntityDatabase food) async {
    return await repository.updateFood(food);
  }
}
