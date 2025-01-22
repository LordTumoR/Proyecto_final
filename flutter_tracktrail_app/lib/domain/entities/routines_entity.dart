import 'package:flutter_tracktrail_app/data/models/user_database_model.dart';

class RoutineEntity {
  final int? id;
  final String? name;
  final String? goal;
  final int? duration;
  final bool? isPrivate;
  final String? difficulty;
  final String? progress;
  final UserDatabaseModel? idUser;
  final String? imageUrl;

  RoutineEntity({
    this.id,
    this.name,
    this.goal,
    this.duration,
    this.isPrivate,
    this.difficulty,
    this.progress,
    this.idUser,
    this.imageUrl,
  });
  @override
  String toString() {
    return 'RoutineEntity(name: $name, goal: $goal, duration: $duration, isPrivate: $isPrivate)';
  }
}
