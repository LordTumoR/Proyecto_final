// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_state.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/nutrition_display/nutrition_tab.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/routine_display/routine_menu.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/user/custom_user_drawer.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/user/user_dialog_registered.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool isUserRegistered = false;

  @override
  void initState() {
    super.initState();
    _checkIfUserIsRegistered();
  }

  Future<void> _checkIfUserIsRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    final isRegistered = prefs.getBool('isRegistered') ?? false;

    setState(() {
      isUserRegistered = isRegistered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TRACKTRAIL',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Colors.black45,
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blueAccent, Colors.lightBlue],
            ),
          ),
        ),
        elevation: 10,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<LoginBloc>().add(LogoutButtonPressed());
              context.go('/login');
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFE3F2FD)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  final email = state.email ?? "Usuario";
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      '${AppLocalizations.of(context)!.welcomeee}: ${email}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    await _checkIfUserIsRegistered();
                    if (isUserRegistered) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const UserInfoDialog();
                        },
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RoutineMenu()),
                      );
                    }
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color.fromARGB(255, 33, 240, 6)
                                    .withOpacity(0.8),
                                Colors.lightBlue.withOpacity(0.8)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.fitness_center,
                                  size: 50, color: Colors.white),
                              SizedBox(height: 10),
                              Text(
                                'Rutinas',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NutritionMenu()),
                    );
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.greenAccent.withOpacity(0.8),
                                Colors.lightGreen.withOpacity(0.8)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.restaurant,
                                  size: 50, color: Colors.white),
                              const SizedBox(height: 10),
                              Text(
                                AppLocalizations.of(context)!.nutrition,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.orangeAccent.withOpacity(0.8),
                                Colors.deepOrange.withOpacity(0.8)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.show_chart,
                                  size: 50, color: Colors.white),
                              const SizedBox(height: 10),
                              Text(
                                AppLocalizations.of(context)!.progresss,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.purpleAccent.withOpacity(0.8),
                                Colors.deepPurple.withOpacity(0.8)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.map,
                                  size: 50, color: Colors.white),
                              const SizedBox(height: 10),
                              Text(
                                AppLocalizations.of(context)!.routes_and_maps,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
