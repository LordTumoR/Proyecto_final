import 'package:flutter_tracktrail_app/data/datasources/firebase_auth_datasource.dart';
import 'package:flutter_tracktrail_app/data/repositories/sign_in_repository_impl.dart';
import 'package:flutter_tracktrail_app/domain/repositories/sign_in_repository.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/register_user_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/resetPassword_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/sign_in_normal_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/sign_in_user_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/sign_out_user_usecase.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // BLocs
  sl.registerFactory<LoginBloc>(
    () => LoginBloc(sl(), sl(), sl(), sl(), sl(), sl()),
  );

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Instancia de Firebase Auth
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Fuentes de datos
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(auth: sl<FirebaseAuth>()),
  );

  // Repositorios
  sl.registerLazySingleton<SignInRepository>(
    () => SignInRepositoryImpl(
        sl<FirebaseAuthDataSource>(), sl<SharedPreferences>()),
  );

  // Casos de uso
  sl.registerLazySingleton<SigninUserUseCase>(
    () => SigninUserUseCase(sl()),
  );
  sl.registerLazySingleton<SignoutUserUseCase>(
    () => SignoutUserUseCase(sl()),
  );
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(sl()),
  );
  sl.registerLazySingleton<SigninNormalUserUseCase>(
    () => SigninNormalUserUseCase(sl()),
  );
  sl.registerLazySingleton<RegisterUserUseCase>(
    () => RegisterUserUseCase(sl()),
  );
  sl.registerLazySingleton<RestorePasswordUseCase>(
    () => RestorePasswordUseCase(sl()),
  );
}
