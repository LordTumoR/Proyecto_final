import 'package:equatable/equatable.dart';
import 'package:flutter_tracktrail_app/domain/entities/routines_entity.dart'; // Importing RoutineEntity

abstract class RoutinesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchRoutinesEvent extends RoutinesEvent {}

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
