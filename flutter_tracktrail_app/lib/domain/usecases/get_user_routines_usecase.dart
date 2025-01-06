import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/entities/routine-exercise.dart';
import 'package:flutter_tracktrail_app/domain/repositories/routine_exercise_reporitory.dart';

class GetUserRoutinesUseCase {
  final RoutineExerciseRepository repository;

  GetUserRoutinesUseCase(this.repository);

  Future<Either<String, List<RoutineExerciseEntity>>> call(String email) async {
    return await repository.getUserRoutines(email);
  }
}
