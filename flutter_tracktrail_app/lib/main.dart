import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/config/router/routes.dart';
import 'package:flutter_tracktrail_app/firebase_options.dart';
import 'package:flutter_tracktrail_app/injection.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Exercises/exercises_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/language/language_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/language/language_state.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/nutrition/nutrition_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/progress/progress_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routine_exercises/routine_exercises_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/users/users_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/date_manager.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DateManager>.value(value: DateManager()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<LoginBloc>()),
          BlocProvider(create: (_) => sl<RoutinesBloc>()),
          BlocProvider(create: (_) => sl<ExercisesBloc>()),
          BlocProvider(create: (_) => sl<RoutineExercisesBloc>()),
          BlocProvider(create: (_) => sl<UserBloc>()),
          BlocProvider(create: (_) => sl<LanguageBloc>()),
          BlocProvider(create: (_) => sl<NutritionBloc>()),
          BlocProvider(create: (_) => sl<FoodBloc>()),
          BlocProvider(create: (_) => sl<ProgressBloc>()),
        ],
        child:
            BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
          return MaterialApp.router(
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            title: 'ProyectoFinal tracktrail',
            theme: ThemeData(primarySwatch: Colors.blue),
            locale: state.locale,
            supportedLocales: const [
              Locale('en'),
              Locale('es'),
              Locale('fr'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        }),
      ),
    );
  }
}
