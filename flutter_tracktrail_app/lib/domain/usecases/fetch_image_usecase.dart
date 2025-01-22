import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/entities/image_entity.dart';
import 'package:flutter_tracktrail_app/domain/repositories/image_repositoriy.dart';

class FetchImagesUseCase {
  final ImageRepository repository;

  FetchImagesUseCase(this.repository);

  Future<Either<Exception, List<ImageEntity>>> call() {
    return repository.fetchImages();
  }
}
