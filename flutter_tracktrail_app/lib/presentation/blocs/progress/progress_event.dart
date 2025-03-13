import 'package:equatable/equatable.dart';

abstract class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object?> get props => [];
}

class FetchEvolutionWeight extends ProgressEvent {
  final int exerciseId;

  FetchEvolutionWeight(this.exerciseId);

  @override
  List<Object?> get props => [exerciseId];
}

class FetchEvolutionRepsSets extends ProgressEvent {
  final int exerciseId;

  FetchEvolutionRepsSets(this.exerciseId);

  @override
  List<Object?> get props => [exerciseId];
}

class FetchPersonalRecords extends ProgressEvent {
  @override
  List<Object?> get props => [];
}

class FetchTrainingStreak extends ProgressEvent {
  final int userId;

  FetchTrainingStreak(this.userId);

  @override
  List<Object?> get props => [userId];
}
