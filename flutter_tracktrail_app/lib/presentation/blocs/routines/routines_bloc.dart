import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/domain/usecases/create_routine_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/delete_routine_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_completion_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_routines_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_user_routines_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/save_routine_with_image_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/upload_image_usecase.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routines_event.dart';

class RoutinesBloc extends Bloc<RoutinesEvent, RoutinesState> {
  final GetRoutinesUseCase getRoutinesUseCase;
  final CreateRoutineUseCase createRoutineUseCase;
  final GetUserRoutinesUseCase getUserRoutinesUseCase;
  final DeleteRoutineUseCase deleteRoutineUseCase;
  final GetCompletionUseCase getCompletionPercentageUseCase;
  final UploadImageUseCase uploadImageUseCase;
  final SaveRoutineWithImageUseCase saveRoutineWithImageUseCase;

  RoutinesBloc(
      this.getRoutinesUseCase,
      this.createRoutineUseCase,
      this.getUserRoutinesUseCase,
      this.deleteRoutineUseCase,
      this.getCompletionPercentageUseCase,
      this.uploadImageUseCase,
      this.saveRoutineWithImageUseCase)
      : super(RoutinesState.initial()) {
    on<FetchRoutinesEvent>(_onFetchRoutines);
    on<CreateRoutineEvent>(_onCreateRoutine);
    on<FetchUserRoutinesEvent>(_onFetchUserRoutines);
    on<DeleteRoutineEvent>(_onDeleteRoutine);
    on<FetchCompletionPercentageEvent>(_onFetchCompletionPercentage);
    on<SaveRoutineWithImageEvent>(_onSaveRoutineWithImage);
  }

  Future<void> _onDeleteRoutine(
      DeleteRoutineEvent event, Emitter<RoutinesState> emit) async {
    emit(RoutinesState.loading());

    final result = await deleteRoutineUseCase.execute(event.idRoutine);

    result.fold(
      (error) => emit(RoutinesState.failure(error)),
      (_) {
        fetchRoutines();
      },
    );
  }

  Future<void> _onFetchRoutines(
      FetchRoutinesEvent event, Emitter<RoutinesState> emit) async {
    emit(RoutinesState.loading());
    final result = await getRoutinesUseCase();

    result.fold(
      (error) => emit(RoutinesState.failure(error)),
      (routines) => emit(RoutinesState.success(routines)),
    );
  }

  Future<void> _onFetchUserRoutines(
      FetchUserRoutinesEvent event, Emitter<RoutinesState> emit) async {
    emit(RoutinesState.loading());

    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final email = sharedPreferences.getString('email') ?? '';

      final result = await getUserRoutinesUseCase(email);

      result.fold(
        (error) => emit(RoutinesState.failure(error)),
        (routines) {
          final filteredRoutines = routines.where((routine) {
            final matchesName = event.filters['name'] == null ||
                (routine.name?.contains(event.filters['name']) ?? false);
            final matchesGoal = event.filters['goal'] == null ||
                (routine.goal?.contains(event.filters['goal']) ?? false);
            final matchesDuration = event.filters['duration'] == null ||
                routine.duration == event.filters['duration'];
            final matchesDifficulty = event.filters['difficulty'] == null ||
                (routine.difficulty != null &&
                    routine.difficulty!.contains(event.filters['difficulty']!));

            final matchesPrivate = event.filters['isPrivate'] == null ||
                routine.isPrivate == event.filters['isPrivate'];

            return matchesName &&
                matchesGoal &&
                matchesDuration &&
                matchesDifficulty &&
                matchesPrivate;
          }).toList();

          emit(RoutinesState.success(filteredRoutines));
        },
      );
    } catch (e) {
      (e);
      emit(RoutinesState.failure('Las rutinas te han petao.'));
    }
  }

  Future<void> _onCreateRoutine(
      CreateRoutineEvent event, Emitter<RoutinesState> emit) async {
    emit(RoutinesState.loading());

    final result = await createRoutineUseCase(
      name: event.name ?? '',
      goal: event.goal ?? '',
      duration: event.duration ?? 0,
      isPrivate: event.isPrivate ?? true,
      difficulty: event.difficulty ?? '',
      progress: event.progress ?? '',
      routineId: event.routineId,
    );

    result.fold(
      (error) => emit(RoutinesState.failure(error)),
      (_) {
        fetchRoutines();
      },
    );
  }

  void fetchRoutines({Map<String, dynamic>? filters}) {
    add(FetchUserRoutinesEvent(filters: filters ?? {}));
  }

  Future<void> _onFetchCompletionPercentage(
      FetchCompletionPercentageEvent event, Emitter<RoutinesState> emit) async {
    emit(RoutinesState.loading());

    final result =
        await getCompletionPercentageUseCase.execute(event.routineId ?? 0);

    result.fold(
      (error) => emit(RoutinesState.failure(error)),
      (percentage) =>
          emit(RoutinesState.successCompletionPercentage(percentage)),
    );
  }

  Future<void> _onSaveRoutineWithImage(
      SaveRoutineWithImageEvent event, Emitter<RoutinesState> emit) async {
    emit(state.copyWith(isSavingRoutine: true));

    try {
      final result =
          await uploadImageUseCase.execute(event.file, event.fileName);
      result.fold(
        (error) {
          emit(RoutinesState.saveRoutineFailure(error.toString()));
        },
        (imageUrl) async {
          final saveResult = await saveRoutineWithImageUseCase.execute(
            imageUrl: imageUrl,
            routineId: event.routineId,
          );

          saveResult.fold(
            (failure) {
              emit(RoutinesState.saveRoutineFailure(failure));
            },
            (_) {
              emit(RoutinesState.saveRoutineSuccess());
            },
          );
        },
      );
    } catch (e) {
      emit(RoutinesState.saveRoutineFailure(e.toString()));
    }
  }
}
