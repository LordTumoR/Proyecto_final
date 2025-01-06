import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/domain/usecases/routine_exercises_usecase.dart';
import 'routine_exercises_event.dart';
import 'routine_exercises_state.dart';

class RoutineExercisesBloc
    extends Bloc<RoutineExercisesEvent, RoutineExercisesState> {
  final GetRoutineExercisesUseCase routineExercisesUseCase;

  RoutineExercisesBloc(this.routineExercisesUseCase)
      : super(RoutineExercisesState.initial()) {
    on<FetchRoutineExercises>(_onFetchRoutineExercises);
  }

  Future<void> _onFetchRoutineExercises(
      FetchRoutineExercises event, Emitter<RoutineExercisesState> emit) async {
    emit(RoutineExercisesState.loading());
    final result = await routineExercisesUseCase();

    result.fold(
      (error) => emit(RoutineExercisesState.failure(error)),
      (routineExercises) =>
          emit(RoutineExercisesState.success(routineExercises)),
    );
  }

  void fetchRoutineExercises() {
    add(FetchRoutineExercises());
  }
}
