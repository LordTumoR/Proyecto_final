import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';
import 'package:flutter_tracktrail_app/domain/usecases/add_routine_exercises_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_routine_exercises_usecase.dart';
import 'routine_exercises_event.dart';
import 'routine_exercises_state.dart';

class RoutineExercisesBloc
    extends Bloc<RoutineExercisesEvent, RoutineExercisesState> {
  final GetRoutineExercisesUseCase routineExercisesUseCase;
  final AddExerciseToRoutineUseCase addExerciseToRoutineUseCase;

  RoutineExercisesBloc(
    this.routineExercisesUseCase,
    this.addExerciseToRoutineUseCase,
  ) : super(RoutineExercisesState.initial()) {
    on<FetchRoutineExercises>(_onFetchRoutineExercises);
    on<AddExerciseToRoutine>(_onAddExerciseToRoutine);
  }

  Future<void> _onFetchRoutineExercises(
      FetchRoutineExercises event, Emitter<RoutineExercisesState> emit) async {
    emit(RoutineExercisesState.loading());
    final result = await routineExercisesUseCase(event.routineId);
    ('Fetched exercises: $result');

    result.fold(
      (error) => emit(RoutineExercisesState.failure(error)),
      (routineExercises) {
        final exercises = routineExercises
            .map((routineExercise) => routineExercise.exercise)
            .toList();

        emit(RoutineExercisesState.success(exercises));
      },
    );
  }

  Future<void> _onAddExerciseToRoutine(
      AddExerciseToRoutine event, Emitter<RoutineExercisesState> emit) async {
    emit(RoutineExercisesState.loading());
    final result = await addExerciseToRoutineUseCase(
      event.routineId,
      event.newExercise,
    );

    result.fold((error) => emit(RoutineExercisesState.failure(error)), (_) {
      add(FetchRoutineExercises(event.routineId));
    });
  }

  void fetchRoutineExercises(int routineId) {
    add(FetchRoutineExercises(routineId));
  }

  void addExerciseToRoutine(int routineId, ExerciseEntity newExercise) {
    add(AddExerciseToRoutine(routineId, newExercise));
  }
}
