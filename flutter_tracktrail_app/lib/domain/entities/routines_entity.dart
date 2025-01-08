import 'package:flutter_tracktrail_app/data/models/user_database_model.dart';

class RoutineEntity {
  final int id;
  final String name;
  final String goal;
  final int duration;
  final bool isPrivate;
  final String difficulty;
  final String progress;
  final UserDatabaseModel? idUser;

  RoutineEntity({
    required this.id,
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
    return 'RoutineEntity(name: $name, goal: $goal, duration: $duration, isPrivate: $isPrivate)';
  }
}
