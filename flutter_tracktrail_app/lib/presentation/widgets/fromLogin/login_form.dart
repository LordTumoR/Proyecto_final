import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/fromLogin/loginWithGoogle_button.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/fromLogin/register_button.dart';
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

        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '𝐋𝐎𝐆𝐈𝐍',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 1, 1, 1),
                      ),
                    ),
                    const SizedBox(height: 30),
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
                              LoginNormalButtonPressed(
                                  email: email, password: password),
                            );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Si no dispones de cuenta puedes crear una aquí o Inicia sesion con Google:',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: RegisterButton(
                            onPressed: () {
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();
                              context.read<LoginBloc>().add(
                                    RegisterButtonPressed(
                                      email: email,
                                      password: password,
                                    ),
                                  );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GoogleRegisterButton(
                            onPressed: () {
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();
                              context.read<LoginBloc>().add(
                                    LoginButtonPressed(
                                      email: email,
                                      password: password,
                                    ),
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
