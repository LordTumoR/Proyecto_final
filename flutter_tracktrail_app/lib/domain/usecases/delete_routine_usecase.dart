import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/repositories/routines_repository.dart';

class DeleteRoutineUseCase {
  final RoutinesRepository repository;

  DeleteRoutineUseCase(this.repository);

  Future<Either<String, void>> execute(int idRoutine) async {
    try {
      return await repository.deleteRoutine(idRoutine);
    } catch (e) {
      return Left("Error inesperado al eliminar la rutina");
    }
  }
}
