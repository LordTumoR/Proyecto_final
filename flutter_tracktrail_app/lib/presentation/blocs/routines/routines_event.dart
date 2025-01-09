import 'package:equatable/equatable.dart';
import 'package:flutter_tracktrail_app/domain/entities/routines_entity.dart'; // Importing RoutineEntity

abstract class RoutinesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchRoutinesEvent extends RoutinesEvent {}

class FetchUserRoutinesEvent extends RoutinesEvent {
  final Map<String, dynamic> filters;

  FetchUserRoutinesEvent({required this.filters});

  @override
  List<Object> get props => [filters];
}

class RoutinesFetched extends RoutinesEvent {
  final List<RoutineEntity> routines;

  RoutinesFetched(this.routines);

  @override
  List<Object> get props => [routines];
}

class RoutinesFetchError extends RoutinesEvent {
  final String message;

  RoutinesFetchError(this.message);

  @override
  List<Object> get props => [message];
}

class CreateRoutineEvent extends RoutinesEvent {
  final String? name;
  final String? goal;
  final int? duration;
  final bool? isPrivate;
  final String? difficulty;
  final String? progress;

  CreateRoutineEvent({
    this.name,
    this.goal,
    this.duration,
    this.isPrivate,
    this.difficulty,
    this.progress,
  });

  @override
  List<Object> get props => [
        name ?? '',
        goal ?? '',
        duration ?? 0,
        isPrivate ?? true,
        difficulty ?? '',
        progress ?? ''
      ];
}
