import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/repositories/progress_repository.dart';

class GetEvolutionRepsSetsUseCase {
  final ProgressRepository repository;

  GetEvolutionRepsSetsUseCase(this.repository);

  Future<Either<String, List<dynamic>>> call(String muscleGroup) async {
    try {
      List<dynamic> result = await repository.getEvolutionRepsSets(muscleGroup);
      return Right(result);
    } catch (e) {
      return Left("Error occurred: $e");
    }
  }
}
