import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';

class ExerciseModel {
  final int? idExercise;
  final String? name;
  final String? description;
  final String? image;
  final DateTime? dateTime;
  final int? repetitions;
  final double? weight;
  final String? muscleGroup;
  final int? sets;

  ExerciseModel({
    int? idExercise,
    String? name,
    String? description,
    String? image,
    DateTime? dateTime,
    int? repetitions,
    double? weight,
    String? muscleGroup,
    int? sets,
  })  : idExercise = idExercise ?? 0,
        name = name ?? '',
        description = description ?? '',
        image = image ?? '',
        dateTime = dateTime,
        repetitions = repetitions,
        weight = weight,
        muscleGroup = muscleGroup ?? '',
        sets = sets ?? 0;

  @override
  String toString() {
    return 'Exercise{idExercise: $idExercise, name: $name, description: $description, image: $image}';
  }

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      idExercise: json['id_exercises'],
      name: json['name'],
      description: json['description'],
      image: json['images'],
      dateTime: json['dateTime'] != null
          ? DateTime.parse(json['dateTime'])
          : DateTime.now(),
      repetitions: json['repetitions'] ?? 0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      muscleGroup: json['muscleGroup'],
      sets: json['sets'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_exercises': idExercise,
      'name': name,
      'description': description,
      'images': image,
      'dateTime': dateTime?.toIso8601String(),
      'repetitions': repetitions,
      'weight': weight,
      'muscleGroup': muscleGroup,
      'sets': sets,
    };
  }

  ExerciseEntity toEntity() {
    return ExerciseEntity(
      id: idExercise ?? 0,
      name: name ?? '',
      description: description ?? '',
      image: image ?? '',
      dateTime: dateTime,
      repetitions: repetitions ?? 0,
      weight: weight ?? 0,
      muscleGroup: muscleGroup,
      sets: sets ?? 0,
    );
  }
}
