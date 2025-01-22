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

  Future<void> _pickImage(String routineId) async {
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
        title: Text(AppLocalizations.of(context)!.create_and_filter_routines),
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

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12.0),
                      title: Text(
                        routine.name ?? '',
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        routine.goal ?? '',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                      leading: Container(
                        width: 10.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: barraColor,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (routine.isPrivate ?? true) ...[
                            const Icon(Icons.lock, color: Colors.deepPurple),
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
                                  return ProgressDialog(routineId: routine.id!);
                                },
                              );
                            },
                            child: const Icon(Icons.percent,
                                color: Colors.deepPurple),
                          ),
                          const SizedBox(width: 8.0),
                          const Icon(Icons.arrow_forward),
                          const SizedBox(width: 8.0),
                          GestureDetector(
                            onTap: () => _pickImage(routine.id! as String),
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: _selectedImage == null
                                  ? const Icon(Icons.add_a_photo)
                                  : Image.file(_selectedImage!),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ExercisesMenu(routine: routine),
                          ),
                        );
                      },
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
