import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/entities/nutrition_entity.dart';

abstract class NutritionRepository {
  Future<Either<String, List<NutritionEntity>>> getNutritionRecords();
  Future<Either<String, NutritionEntity>> createNutritionRecord(
    String name,
    String description,
    DateTime date,
    int userId,
  );
  Future<Either<String, NutritionEntity>> updateNutritionRecord(
    int? id,
    String? name,
    String? description,
    DateTime? date,
    int? userId,
  );
  Future<Either<String, void>> deleteNutritionRecord(int id);
}
