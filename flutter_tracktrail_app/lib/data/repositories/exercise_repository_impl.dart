import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/data/datasources/exercises_datasource.dart';
import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';
import 'package:flutter_tracktrail_app/domain/repositories/exercises_repository.dart';

class ExercisesRepositoryImpl implements ExercisesRepository {
  final ExerciseRemoteDataSource dataSource;

  ExercisesRepositoryImpl(this.dataSource);

  @override
  Future<Either<String, List<ExerciseEntity>>> getexercises() async {
    try {
      final exercises = await dataSource.getexercises();

      final exerciseEntities = exercises.map((exercise) {
        return ExerciseEntity(
          id: exercise.idExercise,
          name: exercise.name,
          description: exercise.description,
          image: exercise.image,
        );
      }).toList();

      return Right(exerciseEntities);
    } catch (e) {
      print(e);

      return Left("Error al obtener los ejercicios");
    }
  }
}