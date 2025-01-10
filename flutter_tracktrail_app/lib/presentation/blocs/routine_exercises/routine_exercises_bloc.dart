import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';
import 'package:flutter_tracktrail_app/domain/usecases/add_routine_exercises_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_routine_exercises_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/update_completed_usecase.dart';
import 'routine_exercises_event.dart';
import 'routine_exercises_state.dart';

class RoutineExercisesBloc
    extends Bloc<RoutineExercisesEvent, RoutineExercisesState> {
  final GetRoutineExercisesUseCase routineExercisesUseCase;
  final AddExerciseToRoutineUseCase addExerciseToRoutineUseCase;
  final UpdateExerciseCompletionStatus updateExerciseCompletionStatus;

  RoutineExercisesBloc(
    this.routineExercisesUseCase,
    this.addExerciseToRoutineUseCase,
    this.updateExerciseCompletionStatus,
  ) : super(RoutineExercisesState.initial()) {
    on<FetchRoutineExercises>(_onFetchRoutineExercises);
    on<AddExerciseToRoutine>(_onAddExerciseToRoutine);
    on<UpdateExerciseCompletionEvent>(_onUpdateExerciseCompletion);
  }

  Future<void> _onFetchRoutineExercises(
      FetchRoutineExercises event, Emitter<RoutineExercisesState> emit) async {
    emit(RoutineExercisesState.loading());
    final result = await routineExercisesUseCase(event.routineId);

    result.fold(
      (error) => emit(RoutineExercisesState.failure(error)),
      (routineExercises) {
        emit(RoutineExercisesState.success(routineExercises));
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

  Future<void> _onUpdateExerciseCompletion(
    UpdateExerciseCompletionEvent event,
    Emitter<RoutineExercisesState> emit,
  ) async {
    emit(RoutineExercisesState.loading());

    final result = await updateExerciseCompletionStatus(
      event.routineExerciseId,
      event.isCompleted,
    );

    result.fold(
      (error) => emit(RoutineExercisesState.failure(error)),
      (_) => add(FetchRoutineExercises(event.routineExerciseId)),
    );
  }

  void fetchRoutineExercises(int routineId) {
    add(FetchRoutineExercises(routineId));
  }

  void addExerciseToRoutine(int routineId, ExerciseEntity newExercise) {
    add(AddExerciseToRoutine(routineId, newExercise));
  }

  void updateExerciseCompletion(int routineExerciseId, bool isCompleted) {
    add(UpdateExerciseCompletionEvent(
      routineExerciseId: routineExerciseId,
      isCompleted: isCompleted,
    ));
  }
}
