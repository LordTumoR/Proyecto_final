import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/entities/routine-exercise.dart';
import 'package:flutter_tracktrail_app/domain/repositories/routine_exercise_reporitory.dart';

class GetRoutineExercisesUseCase {
  final RoutineExerciseRepository repository;

  GetRoutineExercisesUseCase(this.repository);

  Future<Either<String, List<RoutineExerciseEntity>>> call() async {
    return await repository.getRoutineExercises();
  }
}
