import 'package:flutter_tracktrail_app/domain/entities/routines_entity.dart';
import 'package:flutter_tracktrail_app/domain/repositories/routines_repository.dart';
import 'package:dartz/dartz.dart';

class GetRoutinesUseCase {
  final RoutinesRepository repository;

  GetRoutinesUseCase(this.repository);

  Future<Either<String, List<RoutineEntity>>> call() async {
    return await repository.getRoutines();
  }
}
