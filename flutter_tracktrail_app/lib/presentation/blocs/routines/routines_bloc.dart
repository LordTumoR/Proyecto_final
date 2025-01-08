import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/domain/usecases/create_routine_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_routines_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_user_routines_usecase.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routines_event.dart';

class RoutinesBloc extends Bloc<RoutinesEvent, RoutinesState> {
  final GetRoutinesUseCase getRoutinesUseCase;
  final CreateRoutineUseCase createRoutineUseCase;
  final GetUserRoutinesUseCase getUserRoutinesUseCase;

  RoutinesBloc(
    this.getRoutinesUseCase,
    this.createRoutineUseCase,
    this.getUserRoutinesUseCase,
  ) : super(RoutinesState.initial()) {
    on<FetchRoutinesEvent>(_onFetchRoutines);
    on<CreateRoutineEvent>(_onCreateRoutine);
    on<FetchUserRoutinesEvent>(_onFetchUserRoutines);
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
          emit(RoutinesState.success(routines));
        },
      );
    } catch (e) {
      print(e);
      emit(RoutinesState.failure('Error al obtener las rutinas del usuario.'));
    }
  }

  Future<void> _onCreateRoutine(
      CreateRoutineEvent event, Emitter<RoutinesState> emit) async {
    emit(RoutinesState.loading());

    final result = await createRoutineUseCase(
      event.name,
      event.goal,
      event.duration,
      event.isPrivate,
      event.difficulty,
      event.progress,
    );

    result.fold(
      (error) => emit(RoutinesState.failure(error)),
      (_) {
        fetchRoutines();
      },
    );
  }

  void fetchRoutines() {
    add(FetchUserRoutinesEvent());
  }
}
