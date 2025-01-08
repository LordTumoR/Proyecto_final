import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routine_exercises/routine_exercises_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routine_exercises/routine_exercises_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routine_exercises/routine_exercises_state.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/create_exercises.dart'; // Importa el nuevo Drawer

class ExercisesTab extends StatefulWidget {
  final int routineId;

  ExercisesTab({required this.routineId});

  @override
  _ExercisesTabState createState() => _ExercisesTabState();
}

class _ExercisesTabState extends State<ExercisesTab> {
  @override
  void initState() {
    super.initState();
    context
        .read<RoutineExercisesBloc>()
        .fetchRoutineExercises(widget.routineId);
  }

  void _openCreateExerciseDrawer() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CreateExerciseDrawer(
          routineId: widget.routineId,
          onCreate: (newExercise) {
            context
                .read<RoutineExercisesBloc>()
                .add(AddExerciseToRoutine(widget.routineId, newExercise));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ejercicios de rutina'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<RoutineExercisesBloc, RoutineExercisesState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.errorMessage != null) {
              return Center(
                child: Text(
                  'Error: ${state.errorMessage}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (state.exercises != null && state.exercises!.isNotEmpty) {
              final exercises = state.exercises!;

              return ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 3, 185, 34),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      title: Text(
                        exercise.name,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 58, 71, 183),
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        exercise.description,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                      trailing: const Icon(Icons.heart_broken),
                      onTap: () {},
                    ),
                  );
                },
              );
            }

            return const Center(child: Text('No hay ejercicios disponibles.'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateExerciseDrawer,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
