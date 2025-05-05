import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_state.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/exercises_menu.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/routine_display/create_routine_form.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/routine_display/filter_routine_form.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/routine_display/progress_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MisRutinasTab extends StatefulWidget {
  @override
  _MisRutinasTabState createState() => _MisRutinasTabState();
}

class _MisRutinasTabState extends State<MisRutinasTab> {
  File? _selectedImage;

  Future<void> _pickImage(int routineId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      BlocProvider.of<RoutinesBloc>(context).add(
        SaveRoutineWithImageEvent(
          routineId: routineId,
          file: _selectedImage!,
          fileName: pickedFile.name,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<RoutinesBloc>(context)
        .add(FetchUserRoutinesEvent(filters: {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.create_and_filter_routines,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
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
              final routines = state.routines!;

              return ListView.builder(
                itemCount: routines.length,
                itemBuilder: (context, index) {
                  final routine = routines[index];

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
                    height: 220,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 12.0,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: barraColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              width: 100.0,
                              height: 150.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                  image: routine.imageUrl != null &&
                                          routine.imageUrl!.isNotEmpty
                                      ? NetworkImage(routine.imageUrl!)
                                      : const AssetImage(
                                              'assets/placeholder.png')
                                          as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: (_selectedImage == null &&
                                      (routine.imageUrl == null ||
                                          routine.imageUrl!.isEmpty))
                                  ? const Icon(
                                      Icons.image,
                                      size: 40,
                                      color: Colors.white70,
                                    )
                                  : null,
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
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      routine.goal ?? '',
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          if (routine.isPrivate ?? true) ...[
                                            const Icon(
                                              Icons.lock,
                                              color: Colors.deepPurple,
                                            ),
                                          ] else ...[
                                            const Icon(
                                              Icons.lock_open,
                                              color: Colors.deepPurple,
                                            ),
                                          ],
                                          const SizedBox(width: 10.0),
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
                                            child: const Icon(
                                              Icons.percent,
                                              color: Colors.deepPurple,
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
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
                                            child: const Icon(
                                              Icons.arrow_forward,
                                              color: Colors.deepPurple,
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          GestureDetector(
                                            onTap: () => _pickImage(routine.id!),
                                            child: Container(
                                              width: 35,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.grey),
                                              ),
                                              child: const Icon(
                                                Icons.add_a_photo,
                                                color: Colors.deepPurple,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.favorite,
                                              color: routine.isFavorite ?? false
                                                  ? Colors.red
                                                  : Colors.grey,
                                            ),
                                            onPressed: () {
                                              context
                                                  .read<RoutinesBloc>()
                                                  .add(CreateRoutineEvent(
                                                    isFavorite:
                                                        !(routine.isFavorite ??
                                                            false),
                                                    routineId: routine.id,
                                                  ));
                                            },
                                          ),
                                        ],
                                      ),
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

            return Center(
                child:
                    Text(AppLocalizations.of(context)!.no_routines_available));
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
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
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: BlocProvider.of<RoutinesBloc>(context),
                    child: FilterRoutineForm(),
                  ),
                ));
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
