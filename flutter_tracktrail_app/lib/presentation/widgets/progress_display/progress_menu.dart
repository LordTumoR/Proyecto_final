import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/progress/progress_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/progress/progress_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/progress/progress_state.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProgressBloc>(context).add(FetchEvolutionWeight());
    BlocProvider.of<ProgressBloc>(context).add(FetchEvolutionRepsSets());
    BlocProvider.of<ProgressBloc>(context).add(FetchPersonalRecords());
    BlocProvider.of<ProgressBloc>(context).add(FetchTrainingStreak());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progreso'),
        backgroundColor: const Color(0xFFd35400),
      ),
      backgroundColor: const Color(0xFFf4e1c1),
      body: ProgressView(),
    );
  }
}

class ProgressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressBloc, ProgressState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.errorMessage != null) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.0,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return ProgressCard(
                  title: 'Peso Evolutivo',
                  value: state.evolutionWeight?.join(', ') ?? 'No disponible',
                );
              case 1:
                return ProgressCard(
                  title: 'Reps y Sets Evolutivos',
                  value: state.evolutionRepsSets?.join(', ') ?? 'No disponible',
                );
              case 2:
                return ProgressCard(
                  title: 'Récords Personales',
                  value: state.personalRecords?.join(', ') ?? 'No disponible',
                );
              case 3:
                return ProgressCard(
                  title: 'Racha de Entrenamiento',
                  value: state.trainingStreak?.toString() ?? 'No disponible',
                );
              default:
                return Container();
            }
          },
        );
      },
    );
  }
}

class ProgressCard extends StatelessWidget {
  final String title;
  final String value;

  const ProgressCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFe67e22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
