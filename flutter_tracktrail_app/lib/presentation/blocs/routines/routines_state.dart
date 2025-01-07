import 'package:flutter_tracktrail_app/domain/entities/routines_entity.dart';

class RoutinesState {
  final bool isLoading;
  final List<RoutineEntity>? routines;
  final String? errorMessage;

  const RoutinesState({
    this.isLoading = false,
    this.routines,
    this.errorMessage,
  });

  // Método copyWith
  RoutinesState copyWith({
    bool? isLoading,
    List<RoutineEntity>? routines,
    String? errorMessage,
  }) {
    return RoutinesState(
      isLoading: isLoading ?? this.isLoading,
      routines: routines ?? this.routines,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Estados predefinidos
  factory RoutinesState.initial() => const RoutinesState();

  factory RoutinesState.loading() => const RoutinesState(isLoading: true);

  factory RoutinesState.success(List<RoutineEntity> routines) =>
      RoutinesState(routines: routines);

  factory RoutinesState.failure(String errorMessage) =>
      RoutinesState(errorMessage: errorMessage);
}
