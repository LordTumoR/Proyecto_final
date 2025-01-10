import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Exercises/exercises_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Exercises/exercises_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routine_exercises/routine_exercises_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routine_exercises/routine_exercises_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routine_exercises/routine_exercises_state.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/create_exercises.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/edit_exercise.dart';

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
            } else if (state.routineExercises != null &&
                state.routineExercises!.isNotEmpty) {
              final exercises = state.routineExercises!;

              return ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final routineExercise = exercises[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 3, 185, 34),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      title: Text(
                        routineExercise.exercise?.name ?? '',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 58, 71, 183),
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        routineExercise.exercise?.description ?? '',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: routineExercise.completion ?? false,
                            onChanged: (bool? value) {
                              context
                                  .read<RoutineExercisesBloc>()
                                  .updateExerciseCompletion(
                                    routineExercise.idRoutineExercise ?? 0,
                                    value ?? false,
                                  );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.build),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return EditExerciseDialog(
                                    exercise: routineExercise.exercise!,
                                    onEdit: (updatedExercise) {
                                      BlocProvider.of<RoutineExercisesBloc>(
                                              context)
                                          .add(
                                        AddExerciseToRoutine(
                                            widget.routineId, updatedExercise),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirmar eliminación'),
                                    content: const Text(
                                        '¿Estás seguro de que deseas eliminar este ejercicio?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context.read<ExercisesBloc>().add(
                                              DeleteExerciseEvent(
                                                  routineExercise
                                                          .exercise?.id ??
                                                      0));
                                          context
                                              .read<RoutineExercisesBloc>()
                                              .add(
                                                FetchRoutineExercises(
                                                    widget.routineId),
                                              );
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Eliminar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
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
