import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      final router = GoRouter.of(context);
      router.refresh();
    });

    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/splash.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
