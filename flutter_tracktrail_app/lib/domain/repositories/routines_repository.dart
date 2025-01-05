import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/entities/routines_entity.dart';

abstract class RoutinesRepository {
  Future<Either<String, List<RoutineEntity>>> getRoutines();
}
