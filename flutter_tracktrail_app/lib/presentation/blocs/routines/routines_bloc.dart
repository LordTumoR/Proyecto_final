import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_routines_usecase.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_state.dart';
import 'routines_event.dart';

class RoutinesBloc extends Bloc<RoutinesEvent, RoutinesState> {
  final GetRoutinesUseCase getRoutinesUseCase;

  RoutinesBloc(this.getRoutinesUseCase) : super(RoutinesState.initial()) {
    on<FetchRoutinesEvent>(_onFetchRoutines);
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

  void fetchRoutines() {
    add(FetchRoutinesEvent());
  }
}
