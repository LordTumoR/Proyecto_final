import 'package:equatable/equatable.dart';
import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';

abstract class RoutineExercisesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchRoutineExercises extends RoutineExercisesEvent {
  final int routineId;

  FetchRoutineExercises(this.routineId);

  @override
  List<Object> get props => [routineId];
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

  AddExerciseToRoutine(this.routineId, this.newExercise);

  @override
  List<Object> get props => [routineId, newExercise];
}
