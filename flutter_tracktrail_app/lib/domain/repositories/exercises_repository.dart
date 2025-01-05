import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';

abstract class ExercisesRepository {
  Future<Either<String, List<ExerciseEntity>>> getexercises();
}
