import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/repositories/routines_repository.dart';

class CreateRoutineUseCase {
  final RoutinesRepository repository;

  CreateRoutineUseCase(this.repository);

  Future<Either<String, void>> call({
    String name = '',
    String goal = '',
    int duration = 0,
    bool isPrivate = true,
    String difficulty = '',
    String progress = '',
    int? routineId,
    String? imageUrl,
    bool? isFavorite,
  }) async {
    return await repository.createRoutine(
      name,
      goal,
      duration,
      isPrivate,
      difficulty,
      progress,
      routineId,
      imageUrl,
      isFavorite,
    );
  }
}
