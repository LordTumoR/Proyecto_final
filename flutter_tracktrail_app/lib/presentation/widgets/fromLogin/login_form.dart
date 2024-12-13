import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'login_textfield.dart';
import 'login_button.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_state.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        } else if (state.email != null && state.email != "NO_USER") {
          context.go('/user', extra: state.email);
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'SIGN IN',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            LoginTextField(
              controller: emailController,
              hintText: 'Email...',
              icon: Icons.email_outlined,
              isPassword: false,
            ),
            const SizedBox(height: 10),
            LoginTextField(
              controller: passwordController,
              hintText: 'Password...',
              icon: Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            LoginButton(
              onPressed: () {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();
                context.read<LoginBloc>().add(
                      LoginButtonPressed(email: email, password: password),
                    );
              },
            ),
          ],
        );
      },
    );
  }
}
