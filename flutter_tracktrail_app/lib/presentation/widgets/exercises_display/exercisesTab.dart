import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Exercises/exercises_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Exercises/exercises_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routine_exercises/routine_exercises_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routine_exercises/routine_exercises_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routine_exercises/routine_exercises_state.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/create_exercises.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/date_manager.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/edit_exercise.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final fechaSeleccionada = DateManager().selectedDate.value;
    context
        .read<RoutineExercisesBloc>()
        .fetchRoutineExercises(widget.routineId, fechaSeleccionada);
  }

  void _openCreateExerciseDrawer() {
    final fechaSeleccionada = DateManager().selectedDate.value;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CreateExerciseDrawer(
          routineId: widget.routineId,
          onCreate: (newExercise) {
            context.read<RoutineExercisesBloc>().add(AddExerciseToRoutine(
                widget.routineId, newExercise, fechaSeleccionada));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<RoutineExercisesBloc, RoutineExercisesState>(
          builder: (context, state) {
            final fechaSeleccionada = DateManager().selectedDate.value;
            String title;
            title =
                '${AppLocalizations.of(context)!.exercises_of_routine}: ${fechaSeleccionada.toLocal()}';
            return AppBar(title: Text(title));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<RoutineExercisesBloc, RoutineExercisesState>(
          builder: (context, state) {
            final fechaSeleccionada = DateManager().selectedDate.value;
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.errorMessage != null) {
              return Center(
                child: Text(
                  '${AppLocalizations.of(context)!.error}: ${state.errorMessage}',
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
                      color: const Color.fromARGB(255, 167, 63, 211)
                          .withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      title: Text(
                        routineExercise.exercise.name ?? '',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 58, 71, 183),
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        '${routineExercise.exercise.description ?? ''}\n'
                        'Peso: ${routineExercise.exercise.weight ?? 'N/A'} kg | '
                        'Repeticiones: ${routineExercise.exercise.repetitions ?? 'N/A'}',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: routineExercise.completion,
                            onChanged: (bool? value) {
                              context
                                  .read<RoutineExercisesBloc>()
                                  .updateExerciseCompletion(
                                      routineExercise.idRoutineExercise,
                                      value ?? false,
                                      widget.routineId,
                                      fechaSeleccionada);
                              context
                                  .read<RoutineExercisesBloc>()
                                  .fetchRoutineExercises(
                                      widget.routineId, fechaSeleccionada);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.build),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return EditExerciseDialog(
                                    exercise: routineExercise.exercise,
                                    onEdit: (updatedExercise) {
                                      BlocProvider.of<RoutineExercisesBloc>(
                                              context)
                                          .add(
                                        AddExerciseToRoutine(widget.routineId,
                                            updatedExercise, fechaSeleccionada),
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
                                    title: Text(AppLocalizations.of(context)!
                                        .confirm_deletion),
                                    content: Text(AppLocalizations.of(context)!
                                        .confirm_exercise_deletion),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .cancel),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context.read<ExercisesBloc>().add(
                                              DeleteExerciseEvent(
                                                  routineExercise.exercise.id ??
                                                      0));
                                          context
                                              .read<RoutineExercisesBloc>()
                                              .add(
                                                FetchRoutineExercises(
                                                    widget.routineId,
                                                    fechaSeleccionada),
                                              );
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .delete),
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

            return Center(
                child:
                    Text(AppLocalizations.of(context)!.no_exercises_available));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateExerciseDrawer,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
