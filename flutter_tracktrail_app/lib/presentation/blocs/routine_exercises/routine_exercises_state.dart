import 'package:flutter_tracktrail_app/domain/entities/routine-exercise.dart';
import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';

class RoutineExercisesState {
  final bool isLoading;
  final List<RoutineExerciseEntity>? routineExercises;
  final String? errorMessage;
  final List<ExerciseEntity>? exercises;

  const RoutineExercisesState({
    this.isLoading = false,
    this.routineExercises,
    this.errorMessage,
    this.exercises,
  });

  RoutineExercisesState copyWith({
    bool? isLoading,
    List<RoutineExerciseEntity>? routineExercises,
    String? errorMessage,
    List<ExerciseEntity>? exercises,
  }) {
    return RoutineExercisesState(
      isLoading: isLoading ?? this.isLoading,
      routineExercises: routineExercises ?? this.routineExercises,
      errorMessage: errorMessage ?? this.errorMessage,
      exercises: exercises ?? this.exercises,
    );
  }

  // Estados predefinidos
  factory RoutineExercisesState.initial() => const RoutineExercisesState();

  factory RoutineExercisesState.loading() =>
      const RoutineExercisesState(isLoading: true);

  factory RoutineExercisesState.success(List<ExerciseEntity> exercises) =>
      RoutineExercisesState(exercises: exercises);

  factory RoutineExercisesState.failure(String errorMessage) =>
      RoutineExercisesState(errorMessage: errorMessage);
}
