import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/repositories/nutrition_repository.dart';

class DeleteNutritionRecordUseCase {
  final NutritionRepository _nutritionRepository;

  DeleteNutritionRecordUseCase(this._nutritionRepository);

  Future<Either<String, void>> call(int id) async {
    return await _nutritionRepository.deleteNutritionRecord(id);
  }
}
