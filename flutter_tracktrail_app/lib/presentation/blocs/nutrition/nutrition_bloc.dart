import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/domain/repositories/nutrition_repository.dart';
import 'nutrition_event.dart';
import 'nutrition_state.dart';

class NutritionBloc extends Bloc<NutritionEvent, NutritionState> {
  final NutritionRepository nutritionRepository;

  NutritionBloc({required this.nutritionRepository})
      : super(NutritionInitial()) {
    on<FetchNutritionRecords>(_onFetchNutritionRecords);
    on<CreateNutritionRecord>(_onCreateNutritionRecord);
    on<UpdateNutritionRecord>(_onUpdateNutritionRecord);
    on<DeleteNutritionRecord>(_onDeleteNutritionRecord);
  }

  Future<void> _onFetchNutritionRecords(
      FetchNutritionRecords event, Emitter<NutritionState> emit) async {
    emit(NutritionLoading());

    final result = await nutritionRepository.getNutritionRecords();

    result.fold(
      (error) => emit(NutritionOperationFailure(error: error)),
      (nutritionRecords) =>
          emit(NutritionLoaded(nutritionRecords: nutritionRecords)),
    );
  }

  Future<void> _onCreateNutritionRecord(
      CreateNutritionRecord event, Emitter<NutritionState> emit) async {
    emit(NutritionLoading());

    final result = await nutritionRepository.createNutritionRecord(
      event.name,
      event.description,
      event.date,
      event.userId,
    );

    result.fold(
      (error) => emit(NutritionOperationFailure(error: error)),
      (_) {
        emit(NutritionOperationSuccess());
        add(FetchNutritionRecords());
      },
    );
  }

  Future<void> _onUpdateNutritionRecord(
      UpdateNutritionRecord event, Emitter<NutritionState> emit) async {
    emit(NutritionLoading());

    final result = await nutritionRepository.updateNutritionRecord(
      event.id,
      event.name,
      event.description,
      event.date,
      event.userId,
    );

    result.fold(
      (error) => emit(NutritionOperationFailure(error: error)),
      (_) {
        emit(NutritionOperationSuccess());
        add(FetchNutritionRecords());
      },
    );
  }

  Future<void> _onDeleteNutritionRecord(
      DeleteNutritionRecord event, Emitter<NutritionState> emit) async {
    emit(NutritionLoading());

    final result = await nutritionRepository.deleteNutritionRecord(event.id);

    result.fold(
      (error) => emit(NutritionOperationFailure(error: error)),
      (_) {
        emit(NutritionOperationSuccess());
        add(FetchNutritionRecords());
      },
    );
  }
}
