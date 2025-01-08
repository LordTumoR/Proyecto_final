import 'package:flutter/widgets.dart';
import 'package:flutter_tracktrail_app/domain/repositories/sign_in_repository.dart';
import 'package:flutter_tracktrail_app/injection.dart';
import 'package:flutter_tracktrail_app/injection.dart' as di;
import 'package:flutter_tracktrail_app/presentation/blocs/Exercises/exercises_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routine_exercises/routine_exercises_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/screens/login_page.dart';
import 'package:flutter_tracktrail_app/presentation/screens/user_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/user',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<RoutinesBloc>(
            create: (BuildContext context) => di.sl<RoutinesBloc>(),
          ),
          BlocProvider<ExercisesBloc>(
            create: (BuildContext context) => di.sl<ExercisesBloc>(),
          ),
          BlocProvider<RoutineExercisesBloc>(
            create: (BuildContext context) => di.sl<RoutineExercisesBloc>(),
          ),
        ],
        child: const UserPage(),
      ),
    ),
  ],
  redirect: (context, state) async {
    final isLoggedIn = await sl<SignInRepository>().isLoggedIn();
    final loggedIn =
        isLoggedIn.fold((_) => false, (value) => value != "NO_USER");

    if (!loggedIn && state.uri.toString() != '/login') {
      return '/login';
    }
    if (loggedIn && state.uri.toString() == '/login') {
      return '/user';
    }
    return null;
  },
);
