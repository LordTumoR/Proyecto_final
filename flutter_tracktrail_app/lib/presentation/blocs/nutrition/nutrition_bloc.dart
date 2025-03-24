import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/domain/repositories/nutrition_repository.dart';
import 'package:flutter_tracktrail_app/domain/usecases/create_nutrition_record_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/delete_nutrition_record_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_nutrition_record_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/update_nutrition_record_usecase.dart';
import 'nutrition_event.dart';
import 'nutrition_state.dart';

class NutritionBloc extends Bloc<NutritionEvent, NutritionState> {
  final NutritionRecordUseCase nutritionRecordUseCase;
  final CreateNutritionRecordUseCase createNutritionRecordUseCase;
  final UpdateNutritionRecordUseCase updateNutritionRecordUseCase;
  final DeleteNutritionRecordUseCase deleteNutritionRecordUseCase;

  NutritionBloc(
    this.nutritionRecordUseCase,
    this.createNutritionRecordUseCase,
    this.updateNutritionRecordUseCase,
    this.deleteNutritionRecordUseCase,
  ) : super(NutritionInitial()) {
    on<FetchNutritionRecords>(_onFetchNutritionRecords);
    on<CreateNutritionRecord>(_onCreateNutritionRecord);
    on<UpdateNutritionRecord>(_onUpdateNutritionRecord);
    on<DeleteNutritionRecord>(_onDeleteNutritionRecord);
  }
Future<void> _onFetchNutritionRecords(
    FetchNutritionRecords event, Emitter<NutritionState> emit) async {
  emit(NutritionLoading());

  final result = await nutritionRecordUseCase();

  result.fold(
    (error) {
      if (error == 'Error al obtener los registros de nutrición: Exception: SIN DIETAS') {
        emit(NutritionOperationFailure(error: 'SIN DIETAS'));
      } else {
        emit(NutritionOperationFailure(error: error));
      }
    },
    (nutritionRecords) {
      final filteredRecords = nutritionRecords.where((record) {
        final matchesName =
            record.name.toLowerCase().contains(event.name.toLowerCase());
        final matchesDescription = record.description
            .toLowerCase()
            .contains(event.description.toLowerCase());
        final matchesDate = event.date == null || record.date == event.date;

        return matchesName && matchesDescription && matchesDate;
      }).toList();

      if (filteredRecords.isEmpty) {
        emit(NutritionOperationFailure(error: 'SIN DIETAS'));
      } else {
        emit(NutritionLoaded(nutritionRecords: filteredRecords));
      }
    },
  );
}


  Future<void> _onCreateNutritionRecord(
      CreateNutritionRecord event, Emitter<NutritionState> emit) async {
    emit(NutritionLoading());

    final result = await createNutritionRecordUseCase(
      event.name,
      event.description,
      event.date,
      event.userId,
    );

    result.fold(
      (error) => emit(NutritionOperationFailure(error: error)),
      (_) {
        emit(NutritionOperationSuccess());
        add(FetchNutritionRecords(
          name: '',
          description: '',
          date: null,
        ));
      },
    );
  }

  Future<void> _onUpdateNutritionRecord(
      UpdateNutritionRecord event, Emitter<NutritionState> emit) async {
    emit(NutritionLoading());

    final result = await updateNutritionRecordUseCase.call(
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
        add(FetchNutritionRecords(
          name: '',
          description: '',
          date: null,
        ));
      },
    );
  }

  Future<void> _onDeleteNutritionRecord(
      DeleteNutritionRecord event, Emitter<NutritionState> emit) async {
    emit(NutritionLoading());

    final result = await deleteNutritionRecordUseCase(
      event.id,
    );

    result.fold(
      (error) => emit(NutritionOperationFailure(error: error)),
      (_) {
        emit(NutritionOperationSuccess());
        add(FetchNutritionRecords(
          name: '',
          description: '',
          date: null,
        ));
      },
    );
  }
}
