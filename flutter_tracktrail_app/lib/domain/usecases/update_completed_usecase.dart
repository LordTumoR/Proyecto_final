import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/repositories/routine_exercise_reporitory.dart';

class UpdateExerciseCompletionStatus {
  final RoutineExerciseRepository repository;

  UpdateExerciseCompletionStatus(this.repository);

  Future<Either<String, void>> call(
      int routineExerciseId, bool isCompleted) async {
    return await repository.updateCompletionStatus(
        routineExerciseId, isCompleted);
  }
}
