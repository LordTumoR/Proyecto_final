import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/domain/usecases/delete_image_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/fetch_image_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/upload_image_usecase.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/image/image_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/image/image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final FetchImagesUseCase fetchImagesUseCase;
  final UploadImageUseCase uploadImageUseCase;
  final DeleteImageUseCase deleteImageUseCase;

  ImageBloc({
    required this.fetchImagesUseCase,
    required this.uploadImageUseCase,
    required this.deleteImageUseCase,
  }) : super(ImageInitial()) {
    on<FetchImages>((event, emit) async {
      emit(ImageLoading());
      final result = await fetchImagesUseCase();
      result.fold(
        (error) => emit(ImageError(error.toString())),
        (images) => emit(ImageLoaded(images)),
      );
    });

    on<UploadImage>((event, emit) async {
      emit(ImageLoading());
      final result = await uploadImageUseCase(event.file, event.fileName);
      result.fold(
        (error) => emit(ImageError(error.toString())),
        (_) => add(FetchImages()), // Refresca la lista
      );
    });

    on<DeleteImage>((event, emit) async {
      emit(ImageLoading());
      final result = await deleteImageUseCase(event.id);
      result.fold(
        (error) => emit(ImageError(error.toString())),
        (_) => add(FetchImages()), // Refresca la lista
      );
    });
  }
}
