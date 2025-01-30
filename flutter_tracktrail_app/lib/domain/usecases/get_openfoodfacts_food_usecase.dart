import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/entities/openfoodfacts_entity.dart';
import 'package:flutter_tracktrail_app/domain/repositories/openfoodfacts_repository.dart';

class FoodUseCase {
  FoodRepository repository;

  FoodUseCase(this.repository);

  Future<Either<String, List<FoodEntity>>> call() async {
    try {
      return await repository.getRandomFoods();
    } catch (e) {
      return Left('Error al obtener los alimentos $e');
    }
  }
}
