import 'package:flutter_tracktrail_app/domain/entities/routines_entity.dart';

class RoutinesState {
  final bool isLoading;
  final bool isSavingRoutine;
  final List<RoutineEntity>? routines;
  final String? errorMessage;
  final String? saveRoutineError;
  final double? completionPercentage;

  const RoutinesState({
    this.isLoading = false,
    this.isSavingRoutine = false,
    this.routines,
    this.errorMessage,
    this.saveRoutineError,
    this.completionPercentage,
  });

  // Método copyWith
  RoutinesState copyWith({
    bool? isLoading,
    bool? isSavingRoutine,
    List<RoutineEntity>? routines,
    String? errorMessage,
    String? saveRoutineError,
    double? completionPercentage,
  }) {
    return RoutinesState(
      isLoading: isLoading ?? this.isLoading,
      isSavingRoutine: isSavingRoutine ?? this.isSavingRoutine,
      routines: routines ?? this.routines,
      errorMessage: errorMessage ?? this.errorMessage,
      saveRoutineError: saveRoutineError ?? this.saveRoutineError,
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

  factory RoutinesState.savingRoutine() =>
      const RoutinesState(isSavingRoutine: true);

  factory RoutinesState.saveRoutineSuccess() => const RoutinesState();

  factory RoutinesState.saveRoutineFailure(String error) =>
      RoutinesState(saveRoutineError: error);
}
