import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';
import 'package:flutter_tracktrail_app/domain/repositories/exercises_repository.dart';
import 'package:dartz/dartz.dart';

class GetExercisesUseCase {
  final ExercisesRepository repository;

  GetExercisesUseCase(this.repository);

  Future<Either<String, List<ExerciseEntity>>> call() async {
    return await repository.getexercises();
  }
}
