import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/entities/nutrition_entity.dart';
import 'package:flutter_tracktrail_app/domain/repositories/nutrition_repository.dart';

class NutritionRecordUseCase {
  NutritionRepository repository;

  NutritionRecordUseCase(this.repository);

  Future<Either<String, List<NutritionEntity>>> call() async {
    try {
      return await repository.getNutritionRecords();
    } catch (e) {
      return Left('Error al obtener las dietas $e');
    }
  }
}
