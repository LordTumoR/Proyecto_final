import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/routine_display/MisRutinasTab.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/routine_display/TabContent.dart';

class RoutineMenu extends StatefulWidget {
  @override
  _RoutineMenuState createState() => _RoutineMenuState();
}

class _RoutineMenuState extends State<RoutineMenu> {
  @override
  void initState() {
    super.initState();
    context.read<RoutinesBloc>().fetchRoutines();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text(
            'Rutinas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 4.0,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(
                icon: Icon(Icons.fitness_center, size: 30),
                text: "Mis Rutinas",
              ),
              Tab(
                icon: Icon(Icons.search, size: 30),
                text: "Buscar Rutinas",
              ),
              Tab(
                icon: Icon(Icons.favorite, size: 30),
                text: "Favoritas",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MisRutinasTab(),
            const TabContent(
              title: 'Buscar Rutinas',
              icon: Icons.search,
              content: 'Busca nuevas rutinas para tu entrenamiento.',
            ),
            const TabContent(
              title: 'Favoritas',
              icon: Icons.favorite,
              content: 'Tus rutinas favoritas estarán aquí.',
            ),
          ],
        ),
      ),
    );
  }
}
