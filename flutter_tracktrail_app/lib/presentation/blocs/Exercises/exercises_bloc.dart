import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/domain/usecases/delete_exrcise_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_exercises_usecase.dart';
import 'exercises_event.dart';
import 'exercises_state.dart';

class ExercisesBloc extends Bloc<ExercisesEvent, ExercisesState> {
  final GetExercisesUseCase getExercisesUseCase;
  final DeleteExerciseUseCase deleteExerciseUseCase;

  ExercisesBloc(
    this.getExercisesUseCase,
    this.deleteExerciseUseCase,
  ) : super(ExercisesState.initial()) {
    on<FetchExercisesEvent>(_onFetchExercises);
    on<DeleteExerciseEvent>(_onDeleteExercise);
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

  Future<void> _onDeleteExercise(
      DeleteExerciseEvent event, Emitter<ExercisesState> emit) async {
    emit(ExercisesState.loading());

    final result = await deleteExerciseUseCase.execute(event.idExercise);

    result.fold(
      (error) => emit(ExercisesState.failure(error)),
      (_) {
        fetchExercises();
      },
    );
  }

  void fetchExercises() {
    add(FetchExercisesEvent());
  }
}
