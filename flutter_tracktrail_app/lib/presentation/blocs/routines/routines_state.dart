class RoutinesState {
  final bool isLoading;
  final List<dynamic>? routines;
  final String? errorMessage;

  const RoutinesState({
    this.isLoading = false,
    this.routines,
    this.errorMessage,
  });

  // Método copyWith
  RoutinesState copyWith({
    bool? isLoading,
    List<dynamic>? routines,
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

  factory RoutinesState.success(List<dynamic> routines) =>
      RoutinesState(routines: routines);

  factory RoutinesState.failure(String errorMessage) =>
      RoutinesState(errorMessage: errorMessage);
}
