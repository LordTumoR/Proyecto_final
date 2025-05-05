import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/domain/entities/routines_entity.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Exercises/exercises_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routine_exercises/routine_exercises_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_event.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/date_manager.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/exercisesTab.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/routine_display/MisRutinasTab.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/routine_display/edit_routine.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class ExercisesMenu extends StatefulWidget {
  final RoutineEntity routine;

  ExercisesMenu({required this.routine});

  @override
  _ExercisesMenuState createState() => _ExercisesMenuState();
}

class _ExercisesMenuState extends State<ExercisesMenu> {
  DatePickerController _controller = DatePickerController();

  @override
  void initState() {
    super.initState();
    context.read<ExercisesBloc>().fetchExercises();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.routine.name;
    final routineid = widget.routine.id ?? 0;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF9B59B6),
          title: Text(
            '${AppLocalizations.of(context)!.exercises_of} $name',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                _showRoutineSettingsDialog(context);
              },
            ),
          ],
          elevation: 5,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepPurpleAccent, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 120,
                  child: DatePicker(
                    DateTime.now(),
                    controller: _controller,
                    onDateChange: (date) {
                      DateManager().updateDate(date);
                      final updatedFechaSeleccionada = DateManager().selectedDate.value;

                      context.read<RoutineExercisesBloc>().fetchRoutineExercises(
                          widget.routine.id ?? 0, updatedFechaSeleccionada);
                    },
                    monthTextStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.deepPurple,
                    ),
                    dayTextStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.deepPurpleAccent,
                    ),
                    selectedTextColor: const Color(0xFF9B59B6),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ExercisesTab(routineId: routineid),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRoutineSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '${AppLocalizations.of(context)!.modify_routine}: ${widget.routine.name}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.modify_routine),
                leading: const Icon(Icons.edit),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return EditRoutineDialog(widget.routine.id ?? 0);
                    },
                  );
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.delete_routine),
                leading: const Icon(Icons.delete),
                onTap: () {
                  Navigator.pop(context);
                  context
                      .read<RoutinesBloc>()
                      .add(DeleteRoutineEvent(widget.routine.id ?? 0));
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MisRutinasTab(),
                  ),
                );
              },
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: const TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        );
      },
    );
  }
}
