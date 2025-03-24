import 'package:flutter/material.dart';
import 'package:flutter_tracktrail_app/data/datasources/openai_service.dart';
import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/date_manager.dart';

class CreateExerciseDialog extends StatefulWidget {
  final int routineId;
  final Function(ExerciseEntity) onCreate;

  const CreateExerciseDialog({super.key, required this.routineId, required this.onCreate});

  @override
  _CreateExerciseDialogState createState() => _CreateExerciseDialogState();
}

class _CreateExerciseDialogState extends State<CreateExerciseDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repetitionsController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  final fechaSeleccionada = DateManager().selectedDate.value;

  String? selectedMuscleGroup;

  final List<String> muscleGroups = [
    "Pecho",
    "Espalda",
    "Hombros",
    "Bíceps",
    "Tríceps",
    "Abdominales",
    "Piernas",
    "Glúteos"
  ];

  final OpenAIService openAIService = OpenAIService();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.create_exercise,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.exercise_name,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.error_exercise_name;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.exercise_description,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.error_exercise_description;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _weightController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.exercise_weight,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.error_exercise_weight;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _repetitionsController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.exercise_repetitions,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.error_exercise_repetitions;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _setsController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.exercise_sets,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.error_exercise_sets;
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedMuscleGroup,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.exercise_muscleGroup,
                    ),
                    items: muscleGroups.map((String group) {
                      return DropdownMenuItem<String>(
                        value: group,
                        child: Text(group),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMuscleGroup = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.error_exercise_muscleGroup;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newExercise = ExerciseEntity(
                        id: 0,
                        name: _nameController.text,
                        description: _descriptionController.text,
                        image: '',
                        dateTime: fechaSeleccionada,
                        weight: double.tryParse(_weightController.text) ?? 0,
                        repetitions: int.tryParse(_repetitionsController.text) ?? 0,
                        sets: int.tryParse(_setsController.text) ?? 0,
                        muscleGroup: selectedMuscleGroup!,
                      );
                      widget.onCreate(newExercise);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Crear ejercicio'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final quantityController = TextEditingController();
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Generar ejercicios'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButtonFormField<String>(
                              value: selectedMuscleGroup,
                              decoration: const InputDecoration(labelText: 'Grupo muscular'),
                              items: muscleGroups.map((String group) {
                                return DropdownMenuItem<String>(
                                  value: group,
                                  child: Text(group),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedMuscleGroup = newValue;
                                });
                              },
                            ),
                            TextFormField(
                              controller: quantityController,
                              decoration: const InputDecoration(labelText: 'Cantidad de ejercicios'),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              final muscleGroup = selectedMuscleGroup;
                              final quantity = int.tryParse(quantityController.text) ?? 0;
                              if (muscleGroup != null && quantity > 0) {
                                openAIService
                                    .generarEjerciciosYGenerarJson(muscleGroup, quantity)
                                    .then((ejerciciosGeneradosJson) {
                                  final List<ExerciseEntity> ejercicios = ejerciciosGeneradosJson
                                      .map<ExerciseEntity>((json) {
                                    return ExerciseEntity(
                                       id: 0,
                                          name: json['name'],
                                          description: json['description'],
                                          image: json['image'] ?? '',
                                          dateTime: DateTime.parse(json['dateTime']),
                                          weight: (json['weight'] is int)
                                              ? (json['weight'] as int).toDouble()
                                              : json['weight'] as double?, 
                                          repetitions: json['repetitions'] is int
                                              ? json['repetitions'] as int
                                              : int.tryParse(json['repetitions'].toString()) ?? 0,
                                          sets: json['sets'] is int
                                              ? json['sets'] as int
                                              : int.tryParse(json['sets'].toString()) ?? 0, 
                                          muscleGroup: json['muscleGroup'],
                                    );
                                  }).toList();

                                  for (var ejercicio in ejercicios) {
                                    widget.onCreate(ejercicio);
                                  }

                                  Navigator.pop(context);
                                }).catchError((error) {
                                  print("Error al generar los ejercicios: $error");
                                });
                              }
                            },
                            child: const Text('Generar'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Generar ejercicios'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
