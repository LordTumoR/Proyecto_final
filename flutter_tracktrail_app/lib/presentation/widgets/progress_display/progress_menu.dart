// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
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
  final List<String> muscleGroupsWithEmojis = [
    "Pecho 💪", "Espalda 🏋️", "Hombros 🦾", "Bíceps 💥", "Tríceps 🔥",
    "Abdominales 🏆", "Piernas 🦵", "Glúteos 🍑"
  ];
  final List<String> muscleGroupsWithoutEmojis = [
    "Pecho", "Espalda", "Hombros", "Bíceps", "Tríceps",
    "Abdominales", "Piernas", "Glúteos"
  ];

  String selectedMuscleGroupWithEmoji = "Pecho 💪";

  String _getMuscleGroupWithoutEmoji(String emoji) {
    int index = muscleGroupsWithEmojis.indexOf(emoji);
    return muscleGroupsWithoutEmojis[index];
  }

  void _fetchProgressData(String muscleGroupWithEmoji) {
    final muscleGroup = _getMuscleGroupWithoutEmoji(muscleGroupWithEmoji);
    context.read<ProgressBloc>().add(FetchEvolutionWeight(muscleGroup));
    context.read<ProgressBloc>().add(FetchEvolutionRepsSets(muscleGroup));
  }

  @override
  void initState() {
    super.initState();
    _fetchProgressData(selectedMuscleGroupWithEmoji);
    context.read<ProgressBloc>().add(FetchPersonalRecords());
    context.read<ProgressBloc>().add(FetchTrainingStreak());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progreso 📈', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFd35400),
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFf4e1c1),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: const Color(0xFFd35400), width: 2.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButton<String>(
                value: selectedMuscleGroupWithEmoji,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFd35400)),
                iconSize: 30,
                underline: Container(),
                style: const TextStyle(
                  color: Color(0xFFd35400),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                items: muscleGroupsWithEmojis.map((String group) {
                  return DropdownMenuItem<String>(
                    value: group,
                    child: Text(group),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() => selectedMuscleGroupWithEmoji = newValue);
                    _fetchProgressData(newValue);
                  }
                },
              ),
            ),
          ),
          Expanded(child: ProgressView()),
        ],
      ),
    );
  }
}

class ProgressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressBloc, ProgressState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFd35400)));
        }
        if (state.errorMessage != null) {
          return Center(child: Text('Error: ${state.errorMessage}', style: const TextStyle(color: Colors.red)));
        }

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            if (state.evolutionWeight is List)
              ChartCard(
                title: 'Peso Evolutivo ⚖️',
                spots: _mapToSpots(state.evolutionWeight, key: 'weight'),
              ),
            if (state.evolutionRepsSets is List)
              ChartCard(
                title: 'Reps y Sets 🔄',
                spots: _mapToSpots(state.evolutionRepsSets, key: 'reps'),
              ),
            ProgressCard(
              title: 'Récords Personales 🏅',
              value: state.personalRecords is List
                  ? (state.personalRecords as List)
                      .map((e) => '${e['exerciseName']}: ${e['weight']}kg')
                      .join(', ')
                  : 'No disponible',
            ),
            ProgressCard(
              title: 'Racha de Entrenamiento 🔥',
              value: state.trainingStreak?.toString() ?? 'No disponible',
            ),
          ],
        );
      },
    );
  }

  List<FlSpot> _mapToSpots(dynamic data, {required String key}) {
    final List list = data;
    return List.generate(
      list.length,
      (i) {
        final e = list[i];
        if (e is Map && e.containsKey(key)) {
          return FlSpot(i.toDouble(), (e[key] as num).toDouble());
        }
        return const FlSpot(0, 0);
      },
    );
  }
}

class ChartCard extends StatelessWidget {
  final String title;
  final List<FlSpot> spots;

  const ChartCard({required this.title, required this.spots});

  void _showChartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: LineChart(
              LineChartData(
                titlesData: const FlTitlesData(show: true),
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    spots: spots,
                    barWidth: 3,
                    color: Colors.deepOrange,
                    belowBarData: BarAreaData(show: true, color: Colors.deepOrange.withOpacity(0.2)),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el dialog
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showChartDialog(context), // Mostrar gráfico al pulsar el contenedor
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: const BorderSide(color: Color(0xFFd35400), width: 2.0),
        ),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold, color: Color(0xFFd35400))),
              const SizedBox(height: 16),
              const SizedBox(
                height: 70,
                child: Center(
                  child: Text(
                    'Pulsa para ver el gráfico',
                    style: TextStyle(
                      color: Color(0xFFd35400),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressCard extends StatelessWidget {
  final String title;
  final String value;

  const ProgressCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 126, 126, 126), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text(title,
            style: const TextStyle(
              color: Color(0xFFd35400),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        subtitle: Text(value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            )),
      ),
    );
  }
}
