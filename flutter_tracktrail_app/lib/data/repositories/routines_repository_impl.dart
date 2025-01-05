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
      print(e);

      return Left("Error al obtener las rutinas");
    }
  }
}
