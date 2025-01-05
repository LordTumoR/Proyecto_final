import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/repositories/routines_repository.dart';

class CreateRoutineUseCase {
  final RoutinesRepository repository;

  CreateRoutineUseCase(this.repository);

  Future<Either<String, void>> call(
    String name,
    String goal,
    int duration,
    bool isPrivate,
    String difficulty,
    String progress,
  ) async {
    return await repository.createRoutine(
      name,
      goal,
      duration,
      isPrivate,
      difficulty,
      progress,
    );
  }
}
