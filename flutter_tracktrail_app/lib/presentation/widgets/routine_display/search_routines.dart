import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_state.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/exercises_menu.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/routine_display/progress_dialog.dart';

class SearchRoutine extends StatefulWidget {
  const SearchRoutine({super.key});

  @override
  State<SearchRoutine> createState() => _SearchRoutineState();
}

class _SearchRoutineState extends State<SearchRoutine> {
  @override
  void initState() {
    super.initState();
    context.read<RoutinesBloc>().add(FetchRoutinesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buscar Rutinas"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<RoutinesBloc, RoutinesState>(
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
            } else if (state.routines != null && state.routines!.isNotEmpty) {
              final publicRoutines = state.routines!
                  .where((routine) => routine.isPrivate == false)
                  .toList();

              if (publicRoutines.isEmpty) {
                return const Center(
                    child: Text("No hay rutinas públicas disponibles."));
              }

              return ListView.builder(
                itemCount: publicRoutines.length,
                itemBuilder: (context, index) {
                  final routine = publicRoutines[index];

                  Color barraColor;
                  switch (routine.difficulty?.toLowerCase()) {
                    case 'easy':
                      barraColor = Colors.green;
                      break;
                    case 'medium':
                      barraColor = Colors.orange;
                      break;
                    case 'hard':
                      barraColor = Colors.red;
                      break;
                    default:
                      barraColor = Colors.grey;
                  }

                  return SizedBox(
                    height: 200,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.purple[100],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 10.0,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: barraColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Container(
                              width: 100.0,
                              height: 150.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.0),
                                image: DecorationImage(
                                  image: routine.imageUrl != null &&
                                          routine.imageUrl!.isNotEmpty
                                      ? NetworkImage(routine.imageUrl!)
                                      : const AssetImage(
                                              'assets/placeholder.png')
                                          as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      routine.name ?? '',
                                      style: const TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      routine.goal ?? '',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        if (routine.isPrivate ?? true) ...[
                                          const Icon(Icons.lock,
                                              color: Colors.deepPurple),
                                        ] else ...[
                                          const Icon(Icons.lock_open,
                                              color: Colors.deepPurple),
                                        ],
                                        const SizedBox(width: 8.0),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ProgressDialog(
                                                    routineId: routine.id!);
                                              },
                                            );
                                          },
                                          child: const Icon(Icons.percent,
                                              color: Colors.deepPurple),
                                        ),
                                        const SizedBox(width: 8.0),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ExercisesMenu(
                                                    routine: routine);
                                              },
                                            );
                                          },
                                          child:
                                              const Icon(Icons.arrow_forward),
                                        ),
                                        const SizedBox(width: 8.0),
                                        GestureDetector(
                                          onTap: () {
                                            context.read<RoutinesBloc>().add(
                                                  CreateRoutineEvent(
                                                    name: routine.name!,
                                                    goal: routine.goal ?? '',
                                                    duration:
                                                        routine.duration ?? 0,
                                                    isPrivate:
                                                        routine.isPrivate ??
                                                            false,
                                                    difficulty:
                                                        routine.difficulty ??
                                                            'Easy',
                                                    progress:
                                                        routine.progress ?? '',
                                                  ),
                                                );
                                          },
                                          child: const Icon(Icons.add,
                                              color: Colors.deepPurple),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return Center(child: Text('No hay rutinas disponibles.'));
          },
        ),
      ),
    );
  }
}
