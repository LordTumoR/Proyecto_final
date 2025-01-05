import 'package:flutter_tracktrail_app/data/datasources/exercises_datasource.dart';
import 'package:flutter_tracktrail_app/data/datasources/firebase_auth_datasource.dart';
import 'package:flutter_tracktrail_app/data/datasources/routines_datasource.dart';
import 'package:flutter_tracktrail_app/data/repositories/exercise_repository_impl.dart';
import 'package:flutter_tracktrail_app/data/repositories/routines_repository_impl.dart';
import 'package:flutter_tracktrail_app/data/repositories/sign_in_repository_impl.dart';
import 'package:flutter_tracktrail_app/domain/repositories/exercises_repository.dart';
import 'package:flutter_tracktrail_app/domain/repositories/routines_repository.dart';
import 'package:flutter_tracktrail_app/domain/repositories/sign_in_repository.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_exercises_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_routines_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/register_user_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/resetPassword_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/sign_in_normal_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/sign_in_user_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/sign_out_user_usecase.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Exercises/exercises_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // BLocs
  sl.registerFactory<LoginBloc>(
    () => LoginBloc(sl(), sl(), sl(), sl(), sl(), sl()),
  );
  sl.registerFactory<RoutinesBloc>(
    () => RoutinesBloc(sl()),
  );
  sl.registerFactory<ExercisesBloc>(
    () => ExercisesBloc(sl()),
  );
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Instancia de Firebase Auth
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  sl.registerLazySingleton<http.Client>(() => http.Client());

  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(auth: sl<FirebaseAuth>()),
  );
  sl.registerLazySingleton<RoutineRemoteDataSource>(
    () => RoutineRemoteDataSourceImpl(sl<http.Client>()),
  );
  sl.registerLazySingleton<ExerciseRemoteDataSource>(
    () => ExerciseRemoteDataSourceImpl(sl<http.Client>()),
  );

  // Repositorios
  sl.registerLazySingleton<SignInRepository>(
    () => SignInRepositoryImpl(
        sl<FirebaseAuthDataSource>(), sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<RoutinesRepository>(
    () => RoutinesRepositoryImpl(sl<RoutineRemoteDataSource>()),
  );
  sl.registerLazySingleton<ExercisesRepository>(
    () => ExercisesRepositoryImpl(sl<ExerciseRemoteDataSource>()),
  );

  // Casos de uso
  sl.registerLazySingleton<GetExercisesUseCase>(
    () => GetExercisesUseCase(sl()),
  );
  sl.registerLazySingleton<GetRoutinesUseCase>(
    () => GetRoutinesUseCase(sl()),
  );
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
