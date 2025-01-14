import 'package:flutter/material.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/formLogin/background_image.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/formLogin/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.center,
              child: LoginForm(),
            ),
          ),
        ],
      ),
    );
  }
}
