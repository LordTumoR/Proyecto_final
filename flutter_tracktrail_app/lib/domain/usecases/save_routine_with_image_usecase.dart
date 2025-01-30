import 'package:dartz/dartz.dart'; // Asegúrate de tener esta dependencia para manejar Either.
import '../repositories/routines_repository.dart';

class SaveRoutineWithImageUseCase {
  final RoutinesRepository repository;

  SaveRoutineWithImageUseCase(this.repository);

  Future<Either<String, void>> execute({
    required String imageUrl,
    required int routineId,
  }) async {
    try {
      await repository.saveRoutineWithImage(imageUrl, routineId);

      return const Right(null);
    } catch (e) {
      return Left('Error saving routine with image: $e');
    }
  }
}
