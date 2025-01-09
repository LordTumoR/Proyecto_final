import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/users/users_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/users/users_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/users/users_state.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/user/personal_info_drawer.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/user/ress_password_user.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/user/update_user_dialog.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(FetchUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent, Colors.lightBlue],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue[800],
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                if (state.user != null) {
                  final user = state.user;
                  return DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue[800],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            user.avatar ??
                                'https://www.example.com/default-avatar.png',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Bienvenido ${user.name} ${user.surname}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state.error.isNotEmpty) {
                  return DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue[800],
                    ),
                    child: Center(
                        child: Text('Error al cargar usuario: ${state.error}',
                            style: const TextStyle(color: Colors.white))),
                  );
                }

                return DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue[800],
                  ),
                  child: const Center(
                      child: Text('Cargando...',
                          style: TextStyle(color: Colors.white))),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Editar Usuario',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UpdateInfoDialog(
                      onInfoUpdated: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz, color: Colors.white),
              title: const Text('Cambiar Contraseña',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return RessPasswordDialog();
                  },
                );
              },
            ),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state.user == null) {
                  return ListTile(
                    leading: const Icon(Icons.analytics, color: Colors.white),
                    title: const Text('Información Personal',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("No se encontró información del usuario")),
                      );
                    },
                  );
                }

                final user = state.user!;

                return ListTile(
                  leading: const Icon(Icons.analytics, color: Colors.white),
                  title: const Text('Información Personal',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return PersonalInfoDialog(user: user);
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
