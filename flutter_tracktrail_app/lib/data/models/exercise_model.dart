import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';

class ExerciseModel {
  final int? idExercise;
  final String? name;
  final String? description;
  final String? image;
  final DateTime? dateTime;

  ExerciseModel({
    int? idExercise,
    String? name,
    String? description,
    String? image,
    DateTime? dateTime,
  })  : idExercise = idExercise ?? 0,
        name = name ?? '',
        description = description ?? '',
        image = image ?? '',
        dateTime = dateTime;

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
        dateTime: DateTime.parse(json['dateTime']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id_exercises': idExercise,
      'name': name,
      'description': description,
      'images': image,
      'dateTime': dateTime?.toIso8601String(),
    };
  }

  ExerciseEntity toEntity() {
    return ExerciseEntity(
      id: idExercise ?? 0,
      name: name ?? '',
      description: description ?? '',
      image: image ?? '',
      dateTime: dateTime,
    );
  }
}
