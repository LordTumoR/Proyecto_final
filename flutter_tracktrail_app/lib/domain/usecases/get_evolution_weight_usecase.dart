import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/repositories/progress_repository.dart';

class GetEvolutionWeightUseCase {
  final ProgressRepository repository;

  GetEvolutionWeightUseCase(this.repository);

  Future<Either<String, List<dynamic>>> call(int exerciseId) async {
    try {
      List<dynamic> result = await repository.getEvolutionWeight(exerciseId);
      return Right(result);
    } catch (e) {
      return Left("Error occurred: $e");
    }
  }
}
