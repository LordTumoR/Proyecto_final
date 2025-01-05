import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_exercises_usecase.dart';
import 'exercises_event.dart';
import 'exercises_state.dart';

class ExercisesBloc extends Bloc<ExercisesEvent, ExercisesState> {
  final GetExercisesUseCase getExercisesUseCase;

  ExercisesBloc(this.getExercisesUseCase) : super(ExercisesState.initial()) {
    on<FetchExercisesEvent>(_onFetchExercises);
  }

  Future<void> _onFetchExercises(
      FetchExercisesEvent event, Emitter<ExercisesState> emit) async {
    emit(ExercisesState.loading());
    final result = await getExercisesUseCase();

    result.fold(
      (error) => emit(ExercisesState.failure(error)),
      (exercises) => emit(ExercisesState.success(exercises)),
    );
  }

  void fetchExercises() {
    add(FetchExercisesEvent());
  }
}
