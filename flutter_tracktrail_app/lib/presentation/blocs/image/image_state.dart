import 'package:flutter_tracktrail_app/domain/entities/image_entity.dart';

abstract class ImageState {}

class ImageInitial extends ImageState {}

class ImageLoading extends ImageState {}

class ImageLoaded extends ImageState {
  final List<ImageEntity> images;
  ImageLoaded(this.images);
}

class ImageError extends ImageState {
  final String message;
  ImageError(this.message);
}
