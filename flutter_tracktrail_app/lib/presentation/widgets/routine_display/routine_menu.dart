import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/routines/routines_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/routine_display/MisRutinasTab.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/routine_display/TabContent.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RoutineMenu extends StatefulWidget {
  @override
  _RoutineMenuState createState() => _RoutineMenuState();
}

class _RoutineMenuState extends State<RoutineMenu> {
  @override
  void initState() {
    super.initState();
    context.read<RoutinesBloc>().fetchRoutines();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(
            AppLocalizations.of(context)!.routines,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 4.0,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(
                icon: const Icon(Icons.fitness_center, size: 30),
                text: AppLocalizations.of(context)!.my_routines,
              ),
              Tab(
                icon: const Icon(Icons.search, size: 30),
                text: AppLocalizations.of(context)!.search_routines,
              ),
              Tab(
                icon: const Icon(Icons.favorite, size: 30),
                text: AppLocalizations.of(context)!.favorites,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MisRutinasTab(),
            TabContent(
              title: AppLocalizations.of(context)!.search_routines,
              icon: Icons.search,
              content: AppLocalizations.of(context)!.search_new_routines,
            ),
            TabContent(
              title: AppLocalizations.of(context)!.favorites,
              icon: Icons.favorite,
              content: AppLocalizations.of(context)!.your_favorite_routines,
            ),
          ],
        ),
      ),
    );
  }
}
