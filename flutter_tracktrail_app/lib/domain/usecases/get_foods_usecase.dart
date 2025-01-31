import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/entities/food_entity.dart';
import 'package:flutter_tracktrail_app/domain/repositories/food_repository.dart';

class GetNutritionFoods {
  final FoodDatabaseRepository repository;

  GetNutritionFoods(this.repository);

  Future<Either<String, List<FoodEntityDatabase>>> call(int dietId) async {
    try {
      final foods = await repository.getNutritionFoods(dietId);

      return Right(foods);
    } catch (e) {
      return Left('Error al obtener los alimentos de la BD: $e');
    }
  }
}
