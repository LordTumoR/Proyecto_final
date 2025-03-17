import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/data/repositories/progress_repository_impl.dart';
import 'package:flutter_tracktrail_app/domain/repositories/progress_repository.dart';

class GetTrainingStreakUseCase {
  final ProgressRepository repository;

  GetTrainingStreakUseCase(this.repository);

  Future<Either<String, int>> call() async {
    try {
      int result = await repository.getTrainingStreak();
      return Right(result);
    } catch (e) {
      return Left("Error occurred: $e");
    }
  }
}
