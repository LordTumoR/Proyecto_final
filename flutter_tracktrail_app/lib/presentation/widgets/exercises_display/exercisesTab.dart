import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Exercises/exercises_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Exercises/exercises_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routine_exercises/routine_exercises_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routine_exercises/routine_exercises_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routine_exercises/routine_exercises_state.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/create_exercises.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/edit_exercise.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';

class ExercisesTab extends StatefulWidget {
  final int routineId;

  ExercisesTab({required this.routineId});

  @override
  _ExercisesTabState createState() => _ExercisesTabState();
}

class _ExercisesTabState extends State<ExercisesTab> {
  Set<int> expandedTiles = {};
  DateTime fechaSeleccionada = DateTime.now();
  Map<int, Stopwatch> _stopwatches = {}; // Mapa para almacenar los cronómetros por ejercicio
  Map<int, String> _elapsedTime = {}; // Mapa para almacenar el tiempo transcurrido por ejercicio

  @override
  void initState() {
    super.initState();
    context.read<RoutineExercisesBloc>().fetchRoutineExercises(widget.routineId, fechaSeleccionada);
  }

  void _openCreateExerciseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CreateExerciseDialog(
          routineId: widget.routineId,
          onCreate: (newExercise) {
            context.read<RoutineExercisesBloc>().add(
              AddExerciseToRoutine(
                widget.routineId,
                newExercise,
                fechaSeleccionada,
              ),
            );
          },
        );
      },
    );
  }

  // Función para iniciar el cronómetro
  void _startStopwatch(int exerciseId) {
    if (!_stopwatches.containsKey(exerciseId)) {
      _stopwatches[exerciseId] = Stopwatch();
    }
    _stopwatches[exerciseId]?.start();
    _updateElapsedTime(exerciseId);
  }

  // Función para detener el cronómetro
  void _stopStopwatch(int exerciseId) {
    _stopwatches[exerciseId]?.stop();
    _updateElapsedTime(exerciseId);
  }

  // Función para actualizar el tiempo transcurrido
  void _updateElapsedTime(int exerciseId) {
    if (_stopwatches.containsKey(exerciseId)) {
      final elapsed = _stopwatches[exerciseId]?.elapsed ?? Duration.zero;
      setState(() {
        _elapsedTime[exerciseId] = '${elapsed.inMinutes}:${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
      });
      if (_stopwatches[exerciseId]?.isRunning ?? false) {
        Future.delayed(const Duration(seconds: 1), () => _updateElapsedTime(exerciseId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocBuilder<RoutineExercisesBloc, RoutineExercisesState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.errorMessage != null) {
              return Center(
                child: Text(
                  '${AppLocalizations.of(context)!.error}: ${state.errorMessage}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (state.routineExercises != null && state.routineExercises!.isNotEmpty) {
              final exercises = state.routineExercises!;
              return ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final routineExercise = exercises[index];
                  final isExpanded = expandedTiles.contains(routineExercise.idRoutineExercise);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          expandedTiles.remove(routineExercise.idRoutineExercise);
                        } else {
                          expandedTiles.add(routineExercise.idRoutineExercise);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFBA68C8), Color(0xFF8E44AD)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${routineExercise.exercise.name ?? ''} 💪',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              if (_elapsedTime[routineExercise.idRoutineExercise] != null) ...[
                                Text(
                                  _elapsedTime[routineExercise.idRoutineExercise]!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (routineExercise.exercise.description != null) ...[
                            Text(
                              isExpanded
                                  ? routineExercise.exercise.description!
                                  : routineExercise.exercise.description!.length > 60
                                      ? '${routineExercise.exercise.description!.substring(0, 60)}...'
                                      : routineExercise.exercise.description!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 230, 204, 255),
                              ),
                            ),
                          ],
                          if (isExpanded) ...[
                            const SizedBox(height: 10),
                            Text(
                              '🧠 ${"Grupo Muscular"}: ${routineExercise.exercise.muscleGroup ?? "N/A"}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              '🏋️ ${AppLocalizations.of(context)!.weight}: ${routineExercise.exercise.weight ?? 'N/A'} kg',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              '🔁 ${"Reps"}: ${routineExercise.exercise.repetitions ?? 'N/A'}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              '📦 ${"Sets"}: ${routineExercise.exercise.sets ?? 'N/A'}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 10),
                          ],
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Checkbox(
                                value: routineExercise.completion,
                                activeColor: Colors.white,
                                checkColor: Colors.purple,
                                onChanged: (bool? value) {
                                  context.read<RoutineExercisesBloc>().updateExerciseCompletion(
                                        routineExercise.idRoutineExercise,
                                        value ?? false,
                                        widget.routineId,
                                        fechaSeleccionada,
                                      );
                                  context.read<RoutineExercisesBloc>().fetchRoutineExercises(
                                        widget.routineId,
                                        fechaSeleccionada,
                                      );
                                  if (value == true) {
                                    _stopStopwatch(routineExercise.idRoutineExercise); // Detener cronómetro cuando se complete
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.white),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return EditExerciseDialog(
                                        exercise: routineExercise.exercise,
                                        onEdit: (updatedExercise) {
                                          BlocProvider.of<RoutineExercisesBloc>(context).add(
                                            AddExerciseToRoutine(
                                              widget.routineId,
                                              updatedExercise,
                                              fechaSeleccionada,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(AppLocalizations.of(context)!.confirm_deletion),
                                        content: Text(AppLocalizations.of(context)!.confirm_exercise_deletion),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(),
                                            child: Text(AppLocalizations.of(context)!.cancel),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              context.read<ExercisesBloc>().add(
                                                    DeleteExerciseEvent(routineExercise.exercise.id ?? 0),
                                                  );
                                              context.read<RoutineExercisesBloc>().add(
                                                    FetchRoutineExercises(widget.routineId, fechaSeleccionada),
                                                  );
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(AppLocalizations.of(context)!.delete),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          // Botones solo visibles cuando el ejercicio está expandido
                          if (isExpanded) ...[
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(120, 50), backgroundColor: Colors.green, // Color de fondo verde para "Iniciar"
                                  ),
                                  onPressed: () => _startStopwatch(routineExercise.idRoutineExercise),
                                  child: Text("Empezar"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(120, 50), backgroundColor: Colors.red, // Color de fondo rojo para "Detener"
                                  ),
                                  onPressed: () => _stopStopwatch(routineExercise.idRoutineExercise),
                                  child: Text("Detener"),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return Center(
              child: Text(AppLocalizations.of(context)!.no_exercises_available),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateExerciseDialog,
        backgroundColor: const Color(0xFF9B59B6),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
