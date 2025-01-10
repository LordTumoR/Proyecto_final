import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_state.dart';

class ProgressDialog extends StatelessWidget {
  final int routineId;

  const ProgressDialog({Key? key, required this.routineId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<RoutinesBloc>(context)
        .add(FetchCompletionPercentageEvent(routineId));

    return AlertDialog(
      title: const Text('METAS Y PROGRESO'),
      content: BlocBuilder<RoutinesBloc, RoutinesState>(
        builder: (context, state) {
          final completionPercentage = state.completionPercentage ?? 0.0;

          if (state.isLoading) {
            return const CircularProgressIndicator();
          }

          return Text(
            "Porcentaje completado: $completionPercentage%",
            style: const TextStyle(fontSize: 18),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            BlocProvider.of<RoutinesBloc>(context)
                .add(FetchUserRoutinesEvent(filters: {}));
            Navigator.of(context).pop();
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
