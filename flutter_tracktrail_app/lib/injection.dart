import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_tracktrail_app/data/datasources/exercises_datasource.dart';
import 'package:flutter_tracktrail_app/data/datasources/files_firebase_datasource.dart';
import 'package:flutter_tracktrail_app/data/datasources/firebase_auth_datasource.dart';
import 'package:flutter_tracktrail_app/data/datasources/food_datasource.dart';
import 'package:flutter_tracktrail_app/data/datasources/nutrition_datasource.dart';
import 'package:flutter_tracktrail_app/data/datasources/openfoodfacts_datasource.dart';
import 'package:flutter_tracktrail_app/data/datasources/progress_datasource.dart';
import 'package:flutter_tracktrail_app/data/datasources/routine_exercises_datasource.dart';
import 'package:flutter_tracktrail_app/data/datasources/routines_datasource.dart';
import 'package:flutter_tracktrail_app/data/datasources/users_datasource.dart';
import 'package:flutter_tracktrail_app/data/repositories/exercise_repository_impl.dart';
import 'package:flutter_tracktrail_app/data/repositories/food_reposiotry_impl.dart';
import 'package:flutter_tracktrail_app/data/repositories/get_users_info_repository_impl.dart';
import 'package:flutter_tracktrail_app/data/repositories/image_repository_impl.dart';
import 'package:flutter_tracktrail_app/data/repositories/nutrition_repository_impl.dart';
import 'package:flutter_tracktrail_app/data/repositories/openfoodfacts_repository_impl.dart';
import 'package:flutter_tracktrail_app/data/repositories/progress_repository_impl.dart';
import 'package:flutter_tracktrail_app/data/repositories/routine_exercise_repository_impl.dart';
import 'package:flutter_tracktrail_app/data/repositories/routines_repository_impl.dart';
import 'package:flutter_tracktrail_app/data/repositories/sign_in_repository_impl.dart';
import 'package:flutter_tracktrail_app/domain/repositories/exercises_repository.dart';
import 'package:flutter_tracktrail_app/domain/repositories/food_repository.dart';
import 'package:flutter_tracktrail_app/domain/repositories/get_users_info_repository.dart';
import 'package:flutter_tracktrail_app/domain/repositories/image_repositoriy.dart';
import 'package:flutter_tracktrail_app/domain/repositories/nutrition_repository.dart';
import 'package:flutter_tracktrail_app/domain/repositories/openfoodfacts_repository.dart';
import 'package:flutter_tracktrail_app/domain/repositories/progress_repository.dart';
import 'package:flutter_tracktrail_app/domain/repositories/routine_exercise_reporitory.dart';
import 'package:flutter_tracktrail_app/domain/repositories/routines_repository.dart';
import 'package:flutter_tracktrail_app/domain/repositories/sign_in_repository.dart';
import 'package:flutter_tracktrail_app/domain/usecases/add_routine_exercises_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/create_food_database_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/create_nutrition_record_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/create_routine_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/delete_exrcise_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/delete_image_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/delete_nutrition_record_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/delete_routine_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/fetch_image_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_completion_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_evolution_rep_sets_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_evolution_weight_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_exercises_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_foods_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_nutrition_record_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_openfoodfacts_food_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_personal_records_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_product_by_barcode.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_routine_exercises_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_routines_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_training_streak_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_user_routines_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_users_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/register_user_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/resetPassword_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/save_routine_with_image_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/sign_in_normal_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/sign_in_user_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/sign_out_user_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/update_completed_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/update_food_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/update_nutrition_record_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/update_user_in_database_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/upload_image_usecase.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Exercises/exercises_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/food/food_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/language/language_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/nutrition/nutrition_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/nutrition/nutrition_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/progress/progress_bloc.dart';
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
    () => RoutinesBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl()),
  );
  sl.registerFactory<ProgressBloc>(
    () => ProgressBloc(sl(), sl(), sl(), sl()),
  );
  sl.registerFactory<ExercisesBloc>(
    () => ExercisesBloc(sl(), sl()),
  );
  sl.registerFactory<RoutineExercisesBloc>(
    () => RoutineExercisesBloc(sl(), sl(), sl()),
  );
  sl.registerFactory<FoodBloc>(
    () => FoodBloc(sl(), sl(), sl(), sl(), sl()),
  );
  sl.registerFactory<UserBloc>(() => UserBloc(
        sl(),
      ));
  sl.registerFactory<NutritionBloc>(
      () => NutritionBloc(sl(), sl(), sl(), sl()));
  sl.registerFactory<LanguageBloc>(() => LanguageBloc());
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Firebase Auth
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);

  sl.registerLazySingleton<http.Client>(() => http.Client());

  // DataSources
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(auth: sl<FirebaseAuth>()),
  );
  sl.registerLazySingleton<ProgressRemoteDataSource>(
    () => ProgressRemoteDataSourceImpl(sl<http.Client>()),
  );
  sl.registerLazySingleton<FoodRemoteDataSource>(
    () => FoodRemoteDataSourceImpl(sl<http.Client>()),
  );
  sl.registerLazySingleton<FoodDatabaseRemoteDataSource>(
    () => FoodDatabaseRemoteDataSourceImpl(sl<http.Client>()),
  );
  sl.registerLazySingleton<NutritionRemoteDataSource>(
    () => NutritionRemoteDataSourceImpl(sl<http.Client>()),
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
  sl.registerLazySingleton<FirebaseStorageDataSource>(
    () => FirebaseStorageDataSourceImpl(storage: sl()),
  );

  // Repositories
  sl.registerLazySingleton<SignInRepository>(
    () => SignInRepositoryImpl(
        sl<FirebaseAuthDataSource>(), sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<NutritionRepository>(
    () => NutritionRepositoryImpl(sl<NutritionRemoteDataSource>()),
  );
  sl.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(sl<ProgressRemoteDataSource>()),
  );
  sl.registerLazySingleton<FoodDatabaseRepository>(
    () => FoodDatabaseRepositoryImpl(sl<FoodDatabaseRemoteDataSource>()),
  );
  sl.registerLazySingleton<FoodRepository>(
    () => FoodRepositoryImpl(sl<FoodRemoteDataSource>()),
  );
  sl.registerLazySingleton<ImageRepository>(
    () => ImageRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<RoutinesRepository>(
    () => RoutinesRepositoryImpl(
        sl<RoutineRemoteDataSource>(), sl<FirebaseStorageDataSource>()),
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
  sl.registerLazySingleton<NutritionRecordUseCase>(
    () => NutritionRecordUseCase(sl()),
  );
  sl.registerLazySingleton<CreateFood>(
    () => CreateFood(sl()),
  );
  sl.registerLazySingleton<UpdateFood>(
    () => UpdateFood(sl()),
  );
  sl.registerLazySingleton<UpdateNutritionRecordUseCase>(
    () => UpdateNutritionRecordUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteNutritionRecordUseCase>(
    () => DeleteNutritionRecordUseCase(sl()),
  );
  sl.registerLazySingleton<CreateNutritionRecordUseCase>(
    () => CreateNutritionRecordUseCase(sl()),
  );
  sl.registerLazySingleton<GetCompletionUseCase>(
    () => GetCompletionUseCase(sl()),
  );
  sl.registerLazySingleton<GetEvolutionRepsSetsUseCase>(
    () => GetEvolutionRepsSetsUseCase(sl()),
  );
  sl.registerLazySingleton<GetPersonalRecordsUseCase>(
    () => GetPersonalRecordsUseCase(sl()),
  );
  sl.registerLazySingleton<GetEvolutionWeightUseCase>(
    () => GetEvolutionWeightUseCase(sl()),
  );
  sl.registerLazySingleton<GetTrainingStreakUseCase>(
    () => GetTrainingStreakUseCase(sl()),
  );

  sl.registerLazySingleton<UpdateExerciseCompletionStatus>(
    () => UpdateExerciseCompletionStatus(sl()),
  );
  sl.registerLazySingleton<DeleteExerciseUseCase>(
    () => DeleteExerciseUseCase(sl()),
  );
  sl.registerLazySingleton(() => FetchImagesUseCase(sl()));
  sl.registerLazySingleton(() => UploadImageUseCase(sl()));
  sl.registerLazySingleton(() => DeleteImageUseCase(sl()));
  sl.registerLazySingleton<DeleteRoutineUseCase>(
    () => DeleteRoutineUseCase(sl()),
  );
  sl.registerLazySingleton<GetUsersUseCase>(
    () => GetUsersUseCase(sl()),
  );
  sl.registerLazySingleton<GetNutritionFoods>(
    () => GetNutritionFoods(sl()),
  );
  sl.registerLazySingleton<SaveRoutineWithImageUseCase>(
    () => SaveRoutineWithImageUseCase(sl()),
  );
  sl.registerLazySingleton<GetUserRoutinesUseCase>(
    () => GetUserRoutinesUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateUserInDatabaseUseCase>(
    () => UpdateUserInDatabaseUseCase(sl()),
  );
  sl.registerLazySingleton<FoodUseCase>(
    () => FoodUseCase(sl()),
  );
  sl.registerLazySingleton<GetRoutineExercisesUseCase>(
    () => GetRoutineExercisesUseCase(sl()),
  );
  sl.registerLazySingleton<AddExerciseToRoutineUseCase>(
    () => AddExerciseToRoutineUseCase(sl()),
  );
  sl.registerLazySingleton<GetProductByBarcodeUseCase>(
    () => GetProductByBarcodeUseCase(sl()),
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
