import 'package:flutter_tracktrail_app/domain/entities/routine-exercise.dart';

class RoutineExercisesState {
  final bool isLoading;
  final List<RoutineExerciseEntity>? routineExercises;
  final String? errorMessage;

  const RoutineExercisesState({
    this.isLoading = false,
    this.routineExercises,
    this.errorMessage,
  });

  // Método copyWith
  RoutineExercisesState copyWith({
    bool? isLoading,
    List<RoutineExerciseEntity>? routineExercises,
    String? errorMessage,
  }) {
    return RoutineExercisesState(
      isLoading: isLoading ?? this.isLoading,
      routineExercises: routineExercises ?? this.routineExercises,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Estados predefinidos
  factory RoutineExercisesState.initial() => const RoutineExercisesState();

  factory RoutineExercisesState.loading() =>
      const RoutineExercisesState(isLoading: true);

  factory RoutineExercisesState.success(
          List<RoutineExerciseEntity> routineExercises) =>
      RoutineExercisesState(routineExercises: routineExercises);

  factory RoutineExercisesState.failure(String errorMessage) =>
      RoutineExercisesState(errorMessage: errorMessage);
}
