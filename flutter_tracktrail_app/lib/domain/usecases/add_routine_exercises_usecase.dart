import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';
import 'package:flutter_tracktrail_app/domain/repositories/routine_exercise_reporitory.dart';

class AddExerciseToRoutineUseCase {
  final RoutineExerciseRepository repository;

  AddExerciseToRoutineUseCase(this.repository);

  Future<Either<String, void>> call(
      int routineId, ExerciseEntity newExercise) async {
    return await repository.addExerciseToRoutine(routineId, newExercise);
  }
}
