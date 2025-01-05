import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/entities/routines_entity.dart';

abstract class RoutinesRepository {
  Future<Either<String, List<RoutineEntity>>> getRoutines();
  Future<Either<String, RoutineEntity>> createRoutine(
    // Add the createRoutine method
    String name,
    String goal,
    int duration,
    bool isPrivate,
    String difficulty,
    String progress,
  );
}
