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

    // Llama al caso de uso
    final result = await routineExercisesUseCase(event.routineId);

    result.fold(
      (error) {
        print('Error al cargar los ejercicios: $error');
        emit(RoutineExercisesState.failure(error));
      },
      (routineExercises) {
        print('Ejercicios cargados: $routineExercises');
        print('Fecha seleccionada: ${event.dateTime}');

        final filteredExercises = routineExercises.where((exercise) {
          final exerciseDate = exercise.exercise.dateTime?.toLocal();
          final selectedDate = event.dateTime.toLocal();

          if (exerciseDate == null) {
            return false;
          }

          return DateTime(
                exerciseDate.year,
                exerciseDate.month,
                exerciseDate.day,
              ) ==
              DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
              );
        }).toList();

        emit(RoutineExercisesState.success(filteredExercises));
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
      add(FetchRoutineExercises(event.routineId, event.dateTime));
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
      (_) => fetchRoutineExercises(event.routineId, event.dateTime),
    );
  }

  void fetchRoutineExercises(int routineId, DateTime dateTime) {
    add(FetchRoutineExercises(routineId, dateTime));
  }

  void addExerciseToRoutine(
      int routineId, ExerciseEntity newExercise, DateTime dateTime) {
    add(AddExerciseToRoutine(routineId, newExercise, dateTime));
  }

  void updateExerciseCompletion(int routineExerciseId, bool isCompleted,
      int routineId, DateTime dateTime) {
    add(UpdateExerciseCompletionEvent(
        routineId: routineId,
        routineExerciseId: routineExerciseId,
        isCompleted: isCompleted,
        dateTime: dateTime));
  }
}
