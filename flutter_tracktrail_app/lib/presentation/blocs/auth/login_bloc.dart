import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/core/use_case.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/register_user_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/resetPassword_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/sign_in_normal_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/sign_in_user_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/sign_out_user_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SigninUserUseCase signInUserUseCase;
  final SignoutUserUseCase signOutUserUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SigninNormalUserUseCase signinNormalUserUseCase;
  final RegisterUserUseCase registerUserUseCase;
  final RestorePasswordUseCase restorePasswordUseCase;

  LoginBloc(
    this.signInUserUseCase,
    this.signOutUserUseCase,
    this.getCurrentUserUseCase,
    this.signinNormalUserUseCase,
    this.registerUserUseCase,
    this.restorePasswordUseCase,
  ) : super(LoginState.initial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginState.loading());
      final result = await signInUserUseCase(LoginParams(
        email: event.email,
        password: event.password,
      ));
      result.fold(
        (failure) =>
            emit(LoginState.failure("Fallo al realizar el login con google")),
        (user) => emit(LoginState.success(user.email)),
      );
    });
    on<RegisterButtonPressed>((event, emit) async {
      emit(LoginState.loading());
      final result = await registerUserUseCase(RegisterParamsNormal(
        email: event.email,
        password: event.password,
      ));
      result.fold(
        (failure) => emit(LoginState.failure("Fallo al realizar el registro")),
        (user) => emit(LoginState.success(user.email)),
      );
    });
    on<LoginNormalButtonPressed>((event, emit) async {
      emit(LoginState.loading());
      final result = await signinNormalUserUseCase(LoginParamsNormal(
        email: event.email,
        password: event.password,
      ));
      result.fold(
        (failure) => emit(LoginState.failure("Fallo al realizar el login")),
        (user) => emit(LoginState.success(user.email)),
      );
    });
    on<CheckAuthentication>((event, emit) async {
      final result = await getCurrentUserUseCase(NoParams());
      result.fold(
        (failure) =>
            emit(LoginState.failure("Fallo al verificar la autenticación")),
        (username) => emit(LoginState.success(username)),
      );
    });

    on<LogoutButtonPressed>((event, emit) async {
      final result = await signOutUserUseCase(NoParams());
      result.fold(
          (failure) => emit(LoginState.failure("Fallo al realizar el logout")),
          (_) => emit(LoginState.initial()));
    });
    on<ResetPasswordButtonPressed>((event, emit) async {
      final result =
          await restorePasswordUseCase(ResetParamsNormal(email: event.email));

      result.fold(
        (failure) => emit(LoginState.failure(
            "Fallo al realizar la recuperación de contraseña")),
        (_) => emit(LoginState.initial()),
      );
    });
  }
}
