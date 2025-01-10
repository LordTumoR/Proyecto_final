import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/repositories/routines_repository.dart';

class GetCompletionUseCase {
  final RoutinesRepository repository;

  GetCompletionUseCase(this.repository);

  Future<Either<String, int>> execute(int routineId) async {
    try {
      final completionResult = await repository.getCompletion(routineId);
      return completionResult;
    } catch (e) {
      return const Left("Error al obtener el porcentaje de completado");
    }
  }
}
