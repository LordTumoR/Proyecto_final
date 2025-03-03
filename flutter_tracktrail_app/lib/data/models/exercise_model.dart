import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';

class ExerciseModel {
  final int? idExercise;
  final String? name;
  final String? description;
  final String? image;
  final DateTime? dateTime;
  final int? repetitions;
  final double? weight;

  ExerciseModel(
      {int? idExercise,
      String? name,
      String? description,
      String? image,
      DateTime? dateTime,
      int? repetitions,
      double? weight})
      : idExercise = idExercise ?? 0,
        name = name ?? '',
        description = description ?? '',
        image = image ?? '',
        dateTime = dateTime,
        repetitions = repetitions,
        weight = weight;

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
      weight: json['weight'] ?? 0,
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
    );
  }
}
