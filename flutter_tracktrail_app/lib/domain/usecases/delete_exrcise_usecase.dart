import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/repositories/exercises_repository.dart';

class DeleteExerciseUseCase {
  final ExercisesRepository repository;

  DeleteExerciseUseCase(this.repository);

  Future<Either<String, void>> execute(int idExercise) {
    return repository.deleteExercise(idExercise);
  }
}
