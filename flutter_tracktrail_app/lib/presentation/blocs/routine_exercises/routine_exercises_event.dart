import 'package:equatable/equatable.dart';
import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';

abstract class RoutineExercisesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchRoutineExercises extends RoutineExercisesEvent {
  final int routineId;
  final DateTime dateTime;

  FetchRoutineExercises(this.routineId, this.dateTime);

  @override
  List<Object> get props => [routineId, this.dateTime];
}

class RoutineExercisesError extends RoutineExercisesEvent {
  final String message;

  RoutineExercisesError(this.message);

  @override
  List<Object> get props => [message];
}

class AddExerciseToRoutine extends RoutineExercisesEvent {
  final int routineId;
  final ExerciseEntity newExercise;
  final DateTime dateTime;

  AddExerciseToRoutine(this.routineId, this.newExercise, this.dateTime);

  @override
  List<Object> get props => [routineId, newExercise, this.dateTime];
}

class UpdateExerciseCompletionEvent extends RoutineExercisesEvent {
  final DateTime dateTime;
  final int routineId;
  final int routineExerciseId;
  final bool isCompleted;

  UpdateExerciseCompletionEvent({
    required this.dateTime,
    required this.routineId,
    required this.routineExerciseId,
    required this.isCompleted,
  });
}
