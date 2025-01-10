import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/data/datasources/routines_datasource.dart';
import 'package:flutter_tracktrail_app/domain/entities/routines_entity.dart';
import 'package:flutter_tracktrail_app/domain/repositories/routines_repository.dart';

class RoutinesRepositoryImpl implements RoutinesRepository {
  final RoutineRemoteDataSource dataSource;

  RoutinesRepositoryImpl(this.dataSource);

  @override
  Future<Either<String, List<RoutineEntity>>> getRoutines() async {
    try {
      final routines = await dataSource.getRoutines();

      final routineEntities = routines.map((routine) {
        return RoutineEntity(
          id: routine.idRoutine,
          name: routine.name,
          goal: routine.goal,
          duration: routine.duration,
          isPrivate: routine.isPrivate,
          difficulty: routine.difficulty,
          progress: routine.progress,
          idUser: routine.idUser,
        );
      }).toList();

      return Right(routineEntities);
    } catch (e) {
      (e);

      return const Left("Error al obtener las rutinas");
    }
  }

  @override
  Future<Either<String, RoutineEntity>> createRoutine(
    String? name,
    String? goal,
    int? duration,
    bool? isPrivate,
    String? difficulty,
    String? progress,
    int? routineId,
  ) async {
    try {
      final routine = await dataSource.createRoutine(
        name ?? '',
        goal ?? '',
        duration ?? 0,
        isPrivate ?? true,
        difficulty ?? '',
        progress ?? '',
        routineId ?? 0,
      );

      final routineEntity = RoutineEntity(
        id: routine.idRoutine,
        name: routine.name,
        goal: routine.goal,
        duration: routine.duration,
        isPrivate: routine.isPrivate,
        difficulty: routine.difficulty,
        progress: routine.progress,
        idUser: routine.idUser,
      );
      return Right(routineEntity);
    } catch (e) {
      (e);
      return const Left("Error al obtener las rutinas");
    }
  }

  @override
  Future<Either<String, List<RoutineEntity>>> getRoutinesByUserEmail(
      String email) async {
    try {
      final routines = await dataSource.getRoutinesByUserEmail(email);

      final routineEntities = routines.map((routine) {
        return RoutineEntity(
          id: routine.idRoutine,
          name: routine.name,
          goal: routine.goal,
          duration: routine.duration,
          isPrivate: routine.isPrivate,
          difficulty: routine.difficulty,
          progress: routine.progress,
          idUser: routine.idUser,
        );
      }).toList();

      return Right(routineEntities);
    } catch (e) {
      (e);
      return const Left("Error al obtener las rutinas del usuariooooo");
    }
  }

  @override
  Future<Either<String, void>> deleteRoutine(int idRoutine) async {
    try {
      await dataSource.deleteRoutine(idRoutine);
      return const Right(null);
    } catch (e) {
      (e);
      return Left("Error al eliminar la rutina con id $idRoutine");
    }
  }

  @override
  Future<Either<String, int>> getCompletion(int routineId) async {
    try {
      final completion = await dataSource.getCompletion(routineId);
      return Right(completion);
    } catch (e) {
      return const Left("Error al obtener el porcentaje de completado");
    }
  }
}
