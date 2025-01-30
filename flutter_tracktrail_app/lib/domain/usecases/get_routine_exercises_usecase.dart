import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/entities/routine-exercise.dart';
import 'package:flutter_tracktrail_app/domain/repositories/routine_exercise_reporitory.dart';

class GetRoutineExercisesUseCase {
  final RoutineExerciseRepository repository;

  GetRoutineExercisesUseCase(this.repository);

  Future<Either<String, List<RoutineExerciseEntity>>> call(
      int routineId) async {
    try {
      return await repository.getRoutineExercisesByRoutineId(routineId);
    } catch (e) {
      return Left('Error al obtener los ejercicios de rutinaaaaa: $e');
    }
  }
}
