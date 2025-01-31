import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/entities/nutrition_entity.dart';
import 'package:flutter_tracktrail_app/domain/repositories/nutrition_repository.dart';

class UpdateNutritionRecordUseCase {
  final NutritionRepository nutritionRepository;

  UpdateNutritionRecordUseCase(this.nutritionRepository);

  Future<Either<String, NutritionEntity>> call(
    int? id,
    String? name,
    String? description,
    DateTime? date,
    int? userId,
  ) async {
    return await nutritionRepository.updateNutritionRecord(
      id,
      name,
      description,
      date,
      userId,
    );
  }
}
