import 'package:flutter_tracktrail_app/data/models/user_database_model.dart';
import 'package:flutter_tracktrail_app/domain/entities/routines_entity.dart';

class RoutineModel {
  final int? idRoutine;
  final String? name;
  final String? goal;
  final int? duration;
  final bool? isPrivate;
  final String? difficulty;
  final String? progress;
  final UserDatabaseModel? idUser;
  final String? imageUrl;
  final bool? isFavorite;

  RoutineModel({
    this.idRoutine,
    this.name,
    this.goal,
    this.duration,
    this.isPrivate,
    this.difficulty,
    this.progress,
    this.idUser,
    this.imageUrl,
    this.isFavorite,
  });

  @override
  String toString() {
    return 'Routine{idRoutine: $idRoutine, name: $name, goal: $goal, duration: $duration, isPrivate: $isPrivate, difficulty: $difficulty, progress: $progress, idUser: $idUser}';
  }

  factory RoutineModel.fromJson(Map<String, dynamic> json) {
    return RoutineModel(
      idRoutine: json['id_routine'] ?? 0,
      name: json['name'],
      goal: json['goal'],
      duration: json['duration'],
      isPrivate: json['private_public'],
      difficulty: json['dificulty'],
      progress: json['progress'],
      idUser: json['user'] != null
          ? UserDatabaseModel.fromJson(json['user'])
          : null,
      imageUrl: json['imageurl'],
      isFavorite: json['isFavorite'] ?? true,
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
      'imageurl': imageUrl,
      'isFavorite': isFavorite,
    };
  }

  RoutineEntity toEntity() {
    return RoutineEntity(
      id: idRoutine ?? 0,
      name: name ?? 'Unknown',
      goal: goal ?? 'Unknown',
      duration: duration ?? 0,
      isPrivate: isPrivate ?? true,
      difficulty: difficulty ?? 'Unknown',
      progress: progress ?? 'Unknown',
      idUser: idUser,
      imageUrl: imageUrl,
      isFavorite: isFavorite ?? true,
    );
  }
}
