import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_state.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/exercises_menu.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/routine_display/create_routine_form.dart';

class MisRutinasTab extends StatefulWidget {
  @override
  _MisRutinasTabState createState() => _MisRutinasTabState();
}

class _MisRutinasTabState extends State<MisRutinasTab> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<RoutinesBloc>(context).add(FetchRoutinesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
              final routines = state.routines!;

              return ListView.builder(
                itemCount: routines.length,
                itemBuilder: (context, index) {
                  final routine = routines[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      title: Text(
                        routine.name,
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        routine.goal,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: BlocProvider.of<RoutinesBloc>(context),
                              child: ExercisesMenu(routine: routine),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }

            return const Center(child: Text('No hay rutinas disponibles.'));
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_alt),
            label: 'Filtrar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Añadir Rutina',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Filtro no implementado")),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: BlocProvider.of<RoutinesBloc>(context),
                  child: CreateRoutineForm(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
