import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_users_usecase.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/users/users_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/users/users_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase getUsersUseCase;

  UserBloc(this.getUsersUseCase) : super(UserState.initial()) {
    on<FetchUsersEvent>(_onFetchUsers);
  }

  Future<void> _onFetchUsers(
      FetchUsersEvent event, Emitter<UserState> emit) async {
    emit(UserState.loading());
    final result = await getUsersUseCase();

    result.fold(
      (error) => emit(UserState.failure(error)),
      (user) => emit(UserState.success(user)),
    );
  }

  void fetchUsers() {
    add(FetchUsersEvent());
  }
}
