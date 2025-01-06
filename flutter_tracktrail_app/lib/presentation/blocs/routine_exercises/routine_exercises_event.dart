import 'package:equatable/equatable.dart';

abstract class RoutineExercisesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchRoutineExercises extends RoutineExercisesEvent {}

class RoutineExercisesError extends RoutineExercisesEvent {
  final String message;

  RoutineExercisesError(this.message);

  @override
  List<Object> get props => [message];
}
