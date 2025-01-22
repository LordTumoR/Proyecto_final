import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/repositories/image_repositoriy.dart';

class UploadImageUseCase {
  final ImageRepository repository;

  UploadImageUseCase(this.repository);

  Future<Either<Exception, void>> call(dynamic file, String fileName) {
    return repository.uploadImage(file, fileName);
  }
}
