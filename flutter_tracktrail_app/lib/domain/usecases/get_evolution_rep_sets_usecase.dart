import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/repositories/progress_repository.dart';

class GetEvolutionRepsSetsUseCase {
  final ProgressRepository repository;

  GetEvolutionRepsSetsUseCase(this.repository);

  Future<Either<String, List<dynamic>>> call(int exerciseId) async {
    try {
      List<dynamic> result = await repository.getEvolutionRepsSets(exerciseId);
      return Right(result);
    } catch (e) {
      return Left("Error occurred: $e");
    }
  }
}
