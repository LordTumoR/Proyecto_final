import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/repositories/image_repositoriy.dart';

class DeleteImageUseCase {
  final ImageRepository repository;

  DeleteImageUseCase(this.repository);

  Future<Either<Exception, void>> call(String id) {
    return repository.deleteImage(id);
  }
}
