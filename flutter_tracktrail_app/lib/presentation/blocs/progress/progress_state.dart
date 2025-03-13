class ProgressState {
  final bool isLoading;
  final int? trainingStreak;
  final List<dynamic>? evolutionWeight;
  final List<dynamic>? evolutionRepsSets;
  final List<dynamic>? personalRecords;
  final String? errorMessage;

  const ProgressState({
    this.isLoading = false,
    this.trainingStreak,
    this.evolutionWeight,
    this.evolutionRepsSets,
    this.personalRecords,
    this.errorMessage,
  });

  ProgressState copyWith({
    bool? isLoading,
    int? trainingStreak,
    List<dynamic>? evolutionWeight,
    List<dynamic>? evolutionRepsSets,
    List<dynamic>? personalRecords,
    String? errorMessage,
  }) {
    return ProgressState(
      isLoading: isLoading ?? this.isLoading,
      trainingStreak: trainingStreak ?? this.trainingStreak,
      evolutionWeight: evolutionWeight ?? this.evolutionWeight,
      evolutionRepsSets: evolutionRepsSets ?? this.evolutionRepsSets,
      personalRecords: personalRecords ?? this.personalRecords,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Estados predefinidos
  factory ProgressState.initial() => const ProgressState();

  factory ProgressState.loading() => const ProgressState(isLoading: true);

  factory ProgressState.trainingStreakSuccess(int trainingStreak) =>
      ProgressState(trainingStreak: trainingStreak);

  factory ProgressState.evolutionWeightSuccess(List<dynamic> evolutionWeight) =>
      ProgressState(evolutionWeight: evolutionWeight);

  factory ProgressState.evolutionRepsSetsSuccess(
          List<dynamic> evolutionRepsSets) =>
      ProgressState(evolutionRepsSets: evolutionRepsSets);

  factory ProgressState.personalRecordsSuccess(List<dynamic> personalRecords) =>
      ProgressState(personalRecords: personalRecords);

  factory ProgressState.failure(String errorMessage) =>
      ProgressState(errorMessage: errorMessage);
}
