import 'package:flutter_tracktrail_app/data/datasources/exercises_datasource.dart';
import 'package:flutter_tracktrail_app/data/datasources/firebase_auth_datasource.dart';
import 'package:flutter_tracktrail_app/data/datasources/routine_exercises_datasource.dart';
import 'package:flutter_tracktrail_app/data/datasources/routines_datasource.dart';
import 'package:flutter_tracktrail_app/data/datasources/users_datasource.dart';
import 'package:flutter_tracktrail_app/data/repositories/exercise_repository_impl.dart';
import 'package:flutter_tracktrail_app/data/repositories/get_users_info_repository_impl.dart';
import 'package:flutter_tracktrail_app/data/repositories/routine_exercise_repository_impl.dart';
import 'package:flutter_tracktrail_app/data/repositories/routines_repository_impl.dart';
import 'package:flutter_tracktrail_app/data/repositories/sign_in_repository_impl.dart';
import 'package:flutter_tracktrail_app/domain/repositories/exercises_repository.dart';
import 'package:flutter_tracktrail_app/domain/repositories/get_users_info_repository.dart';
import 'package:flutter_tracktrail_app/domain/repositories/routine_exercise_reporitory.dart';
import 'package:flutter_tracktrail_app/domain/repositories/routines_repository.dart';
import 'package:flutter_tracktrail_app/domain/repositories/sign_in_repository.dart';
import 'package:flutter_tracktrail_app/domain/usecases/add_routine_exercises_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/create_routine_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_exercises_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_routine_exercises_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_routines_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_user_routines_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_users_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/register_user_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/resetPassword_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/sign_in_normal_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/sign_in_user_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/sign_out_user_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/update_user_in_database_usecase.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Exercises/exercises_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routine_exercises/routine_exercises_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/users/users_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // BLoCs
  sl.registerFactory<LoginBloc>(
    () => LoginBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl()),
  );
  sl.registerFactory<RoutinesBloc>(
    () => RoutinesBloc(sl(), sl(), sl()),
  );
  sl.registerFactory<ExercisesBloc>(
    () => ExercisesBloc(sl()),
  );
  sl.registerFactory<RoutineExercisesBloc>(
    () => RoutineExercisesBloc(sl(), sl()),
  );
  sl.registerFactory<UserBloc>(() => UserBloc(
        sl(),
      ));

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Firebase Auth
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  sl.registerLazySingleton<http.Client>(() => http.Client());

  // DataSources
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(auth: sl<FirebaseAuth>()),
  );
  sl.registerLazySingleton<RoutineRemoteDataSource>(
    () => RoutineRemoteDataSourceImpl(sl<http.Client>()),
  );
  sl.registerLazySingleton<ExerciseRemoteDataSource>(
    () => ExerciseRemoteDataSourceImpl(sl<http.Client>()),
  );
  sl.registerLazySingleton<RoutineExerciseRemoteDataSource>(
    () => RoutineExerciseRemoteDataSourceImpl(sl<http.Client>()),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl<http.Client>()),
  );

  // Repositories
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
  sl.registerLazySingleton<RoutineExerciseRepository>(
    () => RoutineExerciseRepositoryImpl(sl<RoutineExerciseRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetUsersInfoRepository>(
    () => GetUsersInfoRepositoryImpl(sl<UserRemoteDataSource>()),
  );
  // Use Cases
  sl.registerLazySingleton<GetUsersUseCase>(
    () => GetUsersUseCase(sl()),
  );
  sl.registerLazySingleton<GetUserRoutinesUseCase>(
    () => GetUserRoutinesUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateUserInDatabaseUseCase>(
    () => UpdateUserInDatabaseUseCase(sl()),
  );
  sl.registerLazySingleton<GetRoutineExercisesUseCase>(
    () => GetRoutineExercisesUseCase(sl()),
  );
  sl.registerLazySingleton<AddExerciseToRoutineUseCase>(
    () => AddExerciseToRoutineUseCase(sl()),
  );
  sl.registerLazySingleton<CreateRoutineUseCase>(
    () => CreateRoutineUseCase(sl()),
  );
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
