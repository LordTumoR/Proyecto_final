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
    "Pecho 💪",
    "Espalda 🏋️",
    "Hombros 🦾",
    "Bíceps 💥",
    "Tríceps 🔥",
    "Abdominales 🏆",
    "Piernas 🦵",
    "Glúteos 🍑"
  ];

  final List<String> muscleGroupsWithoutEmojis = [
    "Pecho",
    "Espalda",
    "Hombros",
    "Bíceps",
    "Tríceps",
    "Abdominales",
    "Piernas",
    "Glúteos"
  ];

  String selectedMuscleGroupWithEmoji = "Pecho 💪";

  String _getMuscleGroupWithoutEmoji(String muscleGroupWithEmoji) {
    int index = muscleGroupsWithEmojis.indexOf(muscleGroupWithEmoji);
    return muscleGroupsWithoutEmojis[index];
  }

  void _fetchProgressData(String muscleGroupWithEmoji) {
    String muscleGroupWithoutEmoji =
        _getMuscleGroupWithoutEmoji(muscleGroupWithEmoji);
    BlocProvider.of<ProgressBloc>(context)
        .add(FetchEvolutionWeight(muscleGroupWithoutEmoji));
    BlocProvider.of<ProgressBloc>(context)
        .add(FetchEvolutionRepsSets(muscleGroupWithoutEmoji));
  }

  @override
  void initState() {
    super.initState();
    _fetchProgressData(selectedMuscleGroupWithEmoji);
    BlocProvider.of<ProgressBloc>(context).add(FetchPersonalRecords());
    BlocProvider.of<ProgressBloc>(context).add(FetchTrainingStreak());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progreso 📈',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                icon:
                    const Icon(Icons.arrow_drop_down, color: Color(0xFFd35400)),
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
                    setState(() {
                      selectedMuscleGroupWithEmoji = newValue;
                    });
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
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFFd35400)));
        }
        if (state.errorMessage != null) {
          return Center(
              child: Text('Error: ${state.errorMessage}',
                  style: const TextStyle(color: Colors.red, fontSize: 18)));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: 4,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:

                //map: Es recorre cada element de la llista.

                // e is Map && e.containsKey('message'): Si l'element és un Map i té la clau 'message', es pilla el valor que té eixa clau (e['message']).

                // Si no té la clau 'message', es pilla el valor de la clau 'weight' i es converteix en una cadena amb el sufix "KG" ('${e['weight']} KG').
                return ProgressCard(
                  title: 'Peso Evolutivo ⚖️',
                  value: state.evolutionWeight is List
                      ? (state.evolutionWeight as List)
                          .map((e) => e is Map && e.containsKey('message')
                              ? e['message']
                              : '${e['weight']} KG')
                          .join(', ')
                      : 'No disponible',
                );
              case 1:
                return ProgressCard(
                  title: 'Reps y Sets 🔄',
                  value: state.evolutionRepsSets is List
                      ? (state.evolutionRepsSets as List)
                          .map((e) => e is Map && e.containsKey('message')
                              ? e['message']
                              : '${e['reps']} reps, ${e['sets']} sets')
                          .join(', ')
                      : 'No disponible',
                );

              case 2:
                return ProgressCard(
                  title: 'Récords Personales 🏅',
                  value: state.personalRecords is List
                      ? (state.personalRecords as List)
                          .map((e) => '${e['exerciseName']}: ${e['weight']}kg')
                          .join(', ')
                      : 'No disponible',
                );
              case 3:
                return ProgressCard(
                  title: 'Racha de Entrenamiento 🔥',
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
      color: Colors.white,
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
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFd35400),
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
