import 'package:flutter_tracktrail_app/data/models/user_database_model.dart';
import 'package:flutter_tracktrail_app/domain/entities/routines_entity.dart';

class RoutineModel {
  final int idRoutine;
  final String name;
  final String goal;
  final int duration;
  final bool isPrivate;
  final String difficulty;
  final String progress;
  final UserDatabaseModel? idUser;

  RoutineModel({
    required this.idRoutine,
    required this.name,
    required this.goal,
    required this.duration,
    required this.isPrivate,
    required this.difficulty,
    required this.progress,
    required this.idUser,
  });

  @override
  String toString() {
    return 'Routine{idRoutine: $idRoutine, name: $name, goal: $goal, duration: $duration, isPrivate: $isPrivate, difficulty: $difficulty, progress: $progress, idUser: $idUser}';
  }

  factory RoutineModel.fromJson(Map<String, dynamic> json) {
    return RoutineModel(
      idRoutine: json['id_routine'] ?? 0,
      name: json['name'] ?? 'Unknown',
      goal: json['goal'] ?? 'Unknown',
      duration: json['duration'] ?? 0,
      isPrivate: json['private_public'],
      difficulty: json['dificulty'] ?? 'Unknown',
      progress: json['progress'] ?? 'Unknown',
      idUser: json['user'] != null
          ? UserDatabaseModel.fromJson(json['user'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_routine': idRoutine,
      'name': name,
      'goal': goal,
      'duration': duration,
      'private_public': isPrivate,
      'dificulty': difficulty,
      'progress': progress,
      'id_user': idUser?.toJson(),
    };
  }

  RoutineEntity toEntity() {
    return RoutineEntity(
      id: idRoutine,
      name: name,
      goal: goal,
      duration: duration,
      isPrivate: isPrivate,
      difficulty: difficulty,
      progress: progress,
      idUser: idUser,
    );
  }
}
