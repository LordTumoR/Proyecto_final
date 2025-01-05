class ExercisesState {
  final bool isLoading;
  final List<dynamic>? exercises;
  final String? errorMessage;

  const ExercisesState({
    this.isLoading = false,
    this.exercises,
    this.errorMessage,
  });

  // Método copyWith
  ExercisesState copyWith({
    bool? isLoading,
    List<dynamic>? exercises,
    String? errorMessage,
  }) {
    return ExercisesState(
      isLoading: isLoading ?? this.isLoading,
      exercises: exercises ?? this.exercises,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Estados predefinidos
  factory ExercisesState.initial() => const ExercisesState();

  factory ExercisesState.loading() => const ExercisesState(isLoading: true);

  factory ExercisesState.success(List<dynamic> exercises) =>
      ExercisesState(exercises: exercises);

  factory ExercisesState.failure(String errorMessage) =>
      ExercisesState(errorMessage: errorMessage);
}
