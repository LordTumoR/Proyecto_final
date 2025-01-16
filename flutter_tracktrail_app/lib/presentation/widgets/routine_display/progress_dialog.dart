import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProgressDialog extends StatelessWidget {
  final int routineId;

  const ProgressDialog({Key? key, required this.routineId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<RoutinesBloc>(context)
        .add(FetchCompletionPercentageEvent(routineId));

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.goals_and_progress),
      content: BlocBuilder<RoutinesBloc, RoutinesState>(
        builder: (context, state) {
          final completionPercentage = state.completionPercentage ?? 0.0;

          if (state.isLoading) {
            return const CircularProgressIndicator();
          }

          return Text(
            "${AppLocalizations.of(context)!.completion_percentage}: $completionPercentage%",
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
          child: Text(AppLocalizations.of(context)!.close),
        ),
      ],
    );
  }
}
