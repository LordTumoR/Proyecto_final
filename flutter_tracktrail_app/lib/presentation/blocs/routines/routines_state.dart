import 'package:flutter_tracktrail_app/domain/entities/routines_entity.dart';

class RoutinesState {
  final bool isLoading;
  final List<RoutineEntity>? routines;
  final String? errorMessage;
  final double? completionPercentage;

  const RoutinesState({
    this.isLoading = false,
    this.routines,
    this.errorMessage,
    this.completionPercentage,
  });

  // Método copyWith
  RoutinesState copyWith({
    bool? isLoading,
    List<RoutineEntity>? routines,
    String? errorMessage,
    double? completionPercentage,
  }) {
    return RoutinesState(
      isLoading: isLoading ?? this.isLoading,
      routines: routines ?? this.routines,
      errorMessage: errorMessage ?? this.errorMessage,
      completionPercentage: completionPercentage ?? this.completionPercentage,
    );
  }

  // Estados predefinidos
  factory RoutinesState.initial() => const RoutinesState();

  factory RoutinesState.loading() => const RoutinesState(isLoading: true);

  factory RoutinesState.success(List<RoutineEntity> routines) =>
      RoutinesState(routines: routines);

  factory RoutinesState.successCompletionPercentage(double percentage) =>
      RoutinesState(isLoading: false, completionPercentage: percentage);

  factory RoutinesState.failure(String errorMessage) =>
      RoutinesState(errorMessage: errorMessage);
}
