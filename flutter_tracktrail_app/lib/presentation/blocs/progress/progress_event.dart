import 'package:equatable/equatable.dart';

abstract class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object?> get props => [];
}

class FetchEvolutionWeight extends ProgressEvent {
  final String muscleGroup;

  FetchEvolutionWeight(this.muscleGroup);

  @override
  List<Object?> get props => [muscleGroup];
}

class FetchEvolutionRepsSets extends ProgressEvent {
  final String muscleGroup;

  FetchEvolutionRepsSets(this.muscleGroup);

  @override
  List<Object?> get props => [muscleGroup];
}

class FetchPersonalRecords extends ProgressEvent {
  @override
  List<Object?> get props => [];
}

class FetchTrainingStreak extends ProgressEvent {
  FetchTrainingStreak();

  @override
  List<Object?> get props => [];
}
