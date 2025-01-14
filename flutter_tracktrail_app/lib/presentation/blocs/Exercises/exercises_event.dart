import 'package:equatable/equatable.dart';
import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';

abstract class ExercisesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchExercisesEvent extends ExercisesEvent {}

class ExercisesFetched extends ExercisesEvent {
  final List<ExerciseEntity> exercises;

  ExercisesFetched(this.exercises);

  @override
  List<Object> get props => [exercises];
}

class ExercisesFetchError extends ExercisesEvent {
  final String message;

  ExercisesFetchError(this.message);

  @override
  List<Object> get props => [message];
}

class DeleteExerciseEvent extends ExercisesEvent {
  final int idExercise;

  DeleteExerciseEvent(this.idExercise);

  @override
  List<Object> get props => [idExercise];
}
