import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/entities/routines_entity.dart';
import 'package:flutter_tracktrail_app/domain/repositories/routines_repository.dart';

class GetUserRoutinesUseCase {
  final RoutinesRepository repository;

  GetUserRoutinesUseCase(this.repository);

  Future<Either<String, List<RoutineEntity>>> call(String email) async {
    return await repository.getRoutinesByUserEmail(email);
  }
}
