import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';
import 'package:flutter_tracktrail_app/domain/entities/routine-exercise.dart';

abstract class RoutineExerciseRepository {
  // Future<Either<String, List<RoutineExerciseEntity>>> getRoutineExercises();
  // Future<Either<String, RoutineExerciseEntity>> createRoutineExercise({
  //   required int userId,
  //   required int routineId,
  //   required int exerciseId,
  //   required DateTime dateStart,
  //   required DateTime dateFinish,
  // });
  // Future<Either<String, void>> deleteRoutineExercise(int idRoutineExercise);
  Future<Either<String, void>> addExerciseToRoutine(
      int routineId, ExerciseEntity newExercise);
  Future<Either<String, List<RoutineExerciseEntity>>>
      getRoutineExercisesByRoutineId(int routineId);
}
