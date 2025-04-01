import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/entities/nutrition_entity.dart';
import 'package:flutter_tracktrail_app/domain/repositories/nutrition_repository.dart';

class CreateNutritionRecordUseCase {
  final NutritionRepository repository;

  CreateNutritionRecordUseCase(this.repository);

  Future<Either<String, NutritionEntity>> call(
    String name,
    String description,
    DateTime date,
    int userId,
    String imageUrl,
  ) {
    return repository.createNutritionRecord(
      name,
      description,
      date,
      userId,
      imageUrl,
    );
  }
}
