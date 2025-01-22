import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/entities/routines_entity.dart';

abstract class RoutinesRepository {
  Future<Either<String, List<RoutineEntity>>> getRoutines();
  Future<Either<String, RoutineEntity>> createRoutine(
    String? name,
    String? goal,
    int? duration,
    bool? isPrivate,
    String? difficulty,
    String? progress,
    int? routineId,
    String? imageUrl,
  );
  Future<Either<String, List<RoutineEntity>>> getRoutinesByUserEmail(
      String email);
  Future<Either<String, void>> deleteRoutine(int idRoutine);
  Future<Either<String, double>> getCompletion(int routineId);
}
