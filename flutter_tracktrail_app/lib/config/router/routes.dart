// Define the routes using go_router
import 'package:flutter_tracktrail_app/domain/repositories/sign_in_repository.dart';
import 'package:flutter_tracktrail_app/injection.dart';
import 'package:flutter_tracktrail_app/presentation/screens/login_page.dart';
import 'package:flutter_tracktrail_app/presentation/screens/splash_screen.dart';
import 'package:flutter_tracktrail_app/presentation/screens/user_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    // Ruta para UserPage
    GoRoute(
      path: '/user',
      builder: (context, state) => const UserPage(),
    ),
  ],
  redirect: (context, state) async {
    final isLoggedIn = await sl<SignInRepository>().isLoggedIn();
    final loggedIn =
        isLoggedIn.fold((_) => false, (value) => value != "NO_USER");

    if (state.uri.toString() == '/splash') {}

    if (!loggedIn && state.uri.toString() != '/login') {
      return '/login';
    }

    if (loggedIn && state.uri.toString() == '/login') {
      return '/user';
    }

    return null;
  },
);
