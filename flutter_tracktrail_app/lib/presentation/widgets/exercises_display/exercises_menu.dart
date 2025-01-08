import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/domain/entities/routines_entity.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Exercises/exercises_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/exercisesTab.dart';

class ExercisesMenu extends StatefulWidget {
  final RoutineEntity routine;

  ExercisesMenu({required this.routine});

  @override
  _ExercisesMenuState createState() => _ExercisesMenuState();
}

class _ExercisesMenuState extends State<ExercisesMenu> {
  @override
  void initState() {
    super.initState();
    context.read<ExercisesBloc>().fetchExercises();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.routine.name;
    final routineid = widget.routine.id;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 42, 168, 3),
          title: Text(
            'Ejercicios de  $name',
            style: const TextStyle(
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
                text: "Mis Ejercicios",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ExercisesTab(routineId: routineid),
          ],
        ),
      ),
    );
  }
}
