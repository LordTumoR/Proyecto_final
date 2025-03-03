import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/data/datasources/routine_exercises_datasource.dart';
import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';
import 'package:flutter_tracktrail_app/data/models/exercise_model.dart';
import 'package:flutter_tracktrail_app/domain/entities/routine-exercise.dart';
import 'package:flutter_tracktrail_app/domain/repositories/routine_exercise_reporitory.dart';

class RoutineExerciseRepositoryImpl implements RoutineExerciseRepository {
  final RoutineExerciseRemoteDataSource remoteDataSource;

  RoutineExerciseRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, void>> addExerciseToRoutine(
      int routineId, ExerciseEntity newExerciseEntity) async {
    try {
      final exerciseModel = _mapEntityToModel(newExerciseEntity);
      await remoteDataSource.addExerciseToRoutine(routineId, exerciseModel);
      return const Right(null);
    } catch (e) {
      return Left('Error al agregar ejercicio a la rutina: $e');
    }
  }

  ExerciseModel _mapEntityToModel(ExerciseEntity entity) {
    return ExerciseModel(
        idExercise: entity.id ?? 0,
        name: entity.name ?? '',
        description: entity.description ?? '',
        image: entity.image ?? '',
        dateTime: entity.dateTime,
        repetitions: entity.repetitions,
        weight: entity.weight);
  }

  @override
  Future<Either<String, List<RoutineExerciseEntity>>>
      getRoutineExercisesByRoutineId(int routineId) async {
    try {
      final routineExercises = await remoteDataSource.getAllRoutineExercises();

      final exercisesForRoutine = routineExercises
          .where((exercise) => exercise.routines.idRoutine == routineId)
          .toList();

      final entities =
          exercisesForRoutine.map((model) => model.toEntity()).toList();

      return Right(entities);
    } catch (e) {
      return Left('Error al obtener los ejercicios de rutinaddddd: $e');
    }
  }

  @override
  Future<Either<String, void>> updateCompletionStatus(
      int routineExerciseId, bool isCompleted) async {
    try {
      await remoteDataSource.updateRoutineExerciseCompletion(
          routineExerciseId, isCompleted);
      return const Right(null);
    } catch (e) {
      return Left(
          'Error al actualizar el estado de completado del ejercicio: $e');
    }
  }
}
