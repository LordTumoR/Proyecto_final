import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/data/datasources/routine_exercises_datasource.dart';
import 'package:flutter_tracktrail_app/domain/entities/routine-exercise.dart';
import 'package:flutter_tracktrail_app/domain/repositories/routine_exercise_reporitory.dart';

class RoutineExerciseRepositoryImpl implements RoutineExerciseRepository {
  final RoutineExerciseRemoteDataSource remoteDataSource;

  RoutineExerciseRepositoryImpl(this.remoteDataSource);

  // @override
  // Future<Either<String, RoutineExerciseEntity>> createRoutineExercise({
  //   required int userId,
  //   required int routineId,
  //   required int exerciseId,
  //   required DateTime dateStart,
  //   required DateTime dateFinish,
  // }) async {
  //   try {
  //     final model = await remoteDataSource.createRoutineExercise(
  //       userId: userId,
  //       routineId: routineId,
  //       exerciseId: exerciseId,
  //       dateStart: dateStart,
  //       dateFinish: dateFinish,
  //     );
  //     return Right(model.toEntity());
  //   } catch (e) {
  //     return Left('Error al crear el ejercicio de rutina: $e');
  //   }
  // }

  // @override
  // Future<Either<String, void>> deleteRoutineExercise(
  //     int idRoutineExercise) async {
  //   try {
  //     await remoteDataSource.deleteRoutineExercise(idRoutineExercise);
  //     return const Right(null);
  //   } catch (e) {
  //     return Left('Error al eliminar el ejercicio de rutina: $e');
  //   }
  // }

  @override
  Future<Either<String, List<RoutineExerciseEntity>>>
      getRoutineExercises() async {
    try {
      final models = await remoteDataSource.getRoutineExercises();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left('Error al obtener los ejercicios de rutina: $e');
    }
  }

  @override
  Future<Either<String, List<RoutineExerciseEntity>>> getUserRoutines(
      String email) async {
    try {
      final models = await remoteDataSource.getUserRoutines(email);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left('Error al obtener las rutinas del usuario: $e');
    }
  }
}
