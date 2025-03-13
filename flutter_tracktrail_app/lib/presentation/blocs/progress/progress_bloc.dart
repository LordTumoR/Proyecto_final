import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_evolution_rep_sets_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_evolution_weight_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_personal_records_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_training_streak_usecase.dart';
import 'progress_event.dart';
import 'progress_state.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final GetEvolutionWeightUseCase getEvolutionWeightUseCase;
  final GetEvolutionRepsSetsUseCase getEvolutionRepsSetsUseCase;
  final GetPersonalRecordsUseCase getPersonalRecordsUseCase;
  final GetTrainingStreakUseCase getTrainingStreakUseCase;

  ProgressBloc(
    this.getEvolutionWeightUseCase,
    this.getEvolutionRepsSetsUseCase,
    this.getPersonalRecordsUseCase,
    this.getTrainingStreakUseCase,
  ) : super(ProgressState.initial()) {
    on<FetchEvolutionWeight>(_onFetchEvolutionWeight);
    on<FetchEvolutionRepsSets>(_onFetchEvolutionRepsSets);
    on<FetchPersonalRecords>(_onFetchPersonalRecords);
    on<FetchTrainingStreak>(_onFetchTrainingStreak);
  }

  Future<void> _onFetchEvolutionWeight(
      FetchEvolutionWeight event, Emitter<ProgressState> emit) async {
    emit(ProgressState.loading());
    final result = await getEvolutionWeightUseCase(event.exerciseId);
    result.fold(
      (error) => emit(ProgressState.failure(error)),
      (data) => emit(state.copyWith(evolutionWeight: data, isLoading: false)),
    );
  }

  Future<void> _onFetchEvolutionRepsSets(
      FetchEvolutionRepsSets event, Emitter<ProgressState> emit) async {
    emit(ProgressState.loading());
    final result = await getEvolutionRepsSetsUseCase(event.exerciseId);
    result.fold(
      (error) => emit(ProgressState.failure(error)),
      (data) => emit(state.copyWith(evolutionRepsSets: data, isLoading: false)),
    );
  }

  Future<void> _onFetchPersonalRecords(
      FetchPersonalRecords event, Emitter<ProgressState> emit) async {
    emit(ProgressState.loading());
    final result = await getPersonalRecordsUseCase();
    result.fold(
      (error) => emit(ProgressState.failure(error)),
      (data) => emit(state.copyWith(personalRecords: data, isLoading: false)),
    );
  }

  Future<void> _onFetchTrainingStreak(
      FetchTrainingStreak event, Emitter<ProgressState> emit) async {
    emit(ProgressState.loading());
    final result = await getTrainingStreakUseCase(event.userId);
    result.fold(
      (error) => emit(ProgressState.failure(error)),
      (streak) =>
          emit(state.copyWith(trainingStreak: streak, isLoading: false)),
    );
  }
}
