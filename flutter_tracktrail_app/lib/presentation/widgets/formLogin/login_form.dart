// ignore_for_file: deprecated_member_use
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/formLogin/loginWithGoogle_button.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/formLogin/register_button.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/formLogin/restore_pass_button.dart';
import 'package:go_router/go_router.dart';
import 'login_textfield.dart';
import 'login_button.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repitepasswordController =
      TextEditingController();
  bool isRestoreMode = false;
  bool isRegisterMode = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        } else if (state.email != null && state.email != "NO_USER") {
          context.go('/user');
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
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    if (isRestoreMode || isRegisterMode) ...[
                      Positioned(
                        top: 0,
                        left: 0,
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              isRestoreMode = false;
                              isRegisterMode = false;
                            });
                          },
                        ),
                      ),
                    ],
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isRestoreMode == true) ...[
                          Text(
                            AppLocalizations.of(context)!.recover_password,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 1, 1, 1),
                            ),
                          ),
                        ] else if (isRegisterMode == true) ...[
                          Text(
                            AppLocalizations.of(context)!.register,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 1, 1, 1),
                            ),
                          ),
                        ] else ...[
                          Text(
                            AppLocalizations.of(context)!.login,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 1, 1, 1),
                            ),
                          ),
                        ],
                        LoginTextField(
                          controller: emailController,
                          hintText: AppLocalizations.of(context)!.email_hint,
                          icon: Icons.email_outlined,
                          isPassword: false,
                        ),
                        const SizedBox(height: 10),
                        if (!isRestoreMode) ...[
                          LoginTextField(
                            controller: passwordController,
                            hintText:
                                AppLocalizations.of(context)!.password_hint,
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),
                        ],
                        const SizedBox(height: 20),
                        if (isRegisterMode) ...[
                          LoginTextField(
                            controller: repitepasswordController,
                            hintText: AppLocalizations.of(context)!
                                .repeat_password_hint,
                            icon: Icons.lock_clock_sharp,
                            isPassword: true,
                          ),
                          const SizedBox(height: 20),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: LoginButton(
                                onPressed: () {
                                  final email = emailController.text.trim();
                                  final password =
                                      passwordController.text.trim();
                                  final repitePassword =
                                      repitepasswordController.text.trim();
                                  if (isRegisterMode) {
                                    if (password == repitePassword) {
                                      context.read<LoginBloc>().add(
                                            RegisterButtonPressed(
                                              email: email,
                                              password: password,
                                            ),
                                          );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context)!
                                                .password_dont_match),
                                      ));
                                    }
                                  } else if (isRestoreMode) {
                                    context.read<LoginBloc>().add(
                                          ResetPasswordButtonPressed(
                                            email: email,
                                          ),
                                        );
                                    setState(() {
                                      isRestoreMode = false;
                                    });
                                  } else {
                                    context.read<LoginBloc>().add(
                                          LoginNormalButtonPressed(
                                            email: email,
                                            password: password,
                                          ),
                                        );
                                  }
                                },
                                buttonText: isRegisterMode
                                    ? AppLocalizations.of(context)!
                                        .register_button
                                    : (isRestoreMode
                                        ? AppLocalizations.of(context)!
                                            .send_email
                                        : AppLocalizations.of(context)!
                                            .login_button),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: GoogleRegisterButton(
                                onPressed: () {
                                  final email = emailController.text.trim();
                                  final password =
                                      passwordController.text.trim();
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
                        if (state.errorMessage != null && !isRegisterMode) ...[
                          Text(
                            AppLocalizations.of(context)!.no_account_message,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (isRestoreMode == false) ...[
                                Expanded(
                                  child: RegisterButton(
                                    onPressed: () {
                                      setState(() {
                                        isRegisterMode = true;
                                      });
                                    },
                                  ),
                                ),
                              ],
                              if (isRestoreMode == false) ...[
                                Expanded(
                                  child: RestorePasswordButton(
                                    onPressed: () {
                                      setState(() {
                                        isRestoreMode = true;
                                      });
                                    },
                                  ),
                                ),
                              ],
                              const SizedBox(width: 10),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ],
                    ),
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
