import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/core/use_case.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/register_user_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/resetPassword_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/sign_in_normal_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/sign_in_user_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/sign_out_user_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/update_user_in_database_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SigninUserUseCase signInUserUseCase;
  final SignoutUserUseCase signOutUserUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SigninNormalUserUseCase signinNormalUserUseCase;
  final RegisterUserUseCase registerUserUseCase;
  final RestorePasswordUseCase restorePasswordUseCase;
  final UpdateUserInDatabaseUseCase updateUserInDatabaseUseCase;
  LoginBloc(
    this.signInUserUseCase,
    this.signOutUserUseCase,
    this.getCurrentUserUseCase,
    this.signinNormalUserUseCase,
    this.registerUserUseCase,
    this.restorePasswordUseCase,
    this.updateUserInDatabaseUseCase,
  ) : super(LoginState.initial()) {
    _initializeState();
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

      await result.fold(
        (failure) async {
          emit(LoginState.failure("Fallo al realizar el registro"));
        },
        (user) async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', user.email);
          await prefs.setBool('isRegistered', true);

          emit(LoginState.success(user.email));
        },
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
    on<UpdateUserDataEvent>((event, emit) async {
      emit(LoginState.loading());

      try {
        final prefs = await SharedPreferences.getInstance();
        final email = prefs.getString('email');

        if (email == null || email.isEmpty) {
          emit(LoginState.failure("Email no encontrado"));
          return;
        }

        final userParams = UserParams(
          email: email,
          name: event.name,
          surname: event.surname,
          password: event.password,
          weight: event.weight,
          dateOfBirth: event.dateOfBirth,
          sex: event.sex,
          height: event.height,
          avatar: event.avatar,
        );
        await updateUserInDatabaseUseCase(userParams);

        final result = await getCurrentUserUseCase(NoParams());

        bool? isRegistered = prefs.getBool('isRegistered');
        if (isRegistered == true) {
          await prefs.remove('isRegistered');
          print('La propiedad "isRegistered" ha sido eliminada.');
        } else {
          print(
              'La propiedad "isRegistered" no existe o ya ha sido eliminada.');
        }

        result.fold(
          (failure) =>
              emit(LoginState.failure("Fallo al obtener datos actualizados")),
          (username) => emit(LoginState.success(username)),
        );
      } catch (error) {
        emit(LoginState.failure("Fallo al actualizar el usuario"));
      }
    });
  }
  Future<void> _initializeState() async {
    final prefs = await SharedPreferences.getInstance();
    final emailSharedPrefs = prefs.getString('email');
    if (emailSharedPrefs != null && emailSharedPrefs.isNotEmpty) {
      emit(LoginState.success(emailSharedPrefs));
    } else {
      emit(LoginState.initial());
    }
  }
}
