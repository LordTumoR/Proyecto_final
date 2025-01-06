import 'package:flutter_tracktrail_app/domain/entities/exercises_entity.dart';
import 'package:flutter_tracktrail_app/domain/entities/routines_entity.dart';
import 'package:flutter_tracktrail_app/domain/entities/user_database_entity.dart';

class RoutineExerciseEntity {
  final int idRoutineExercise;
  final DateTime dateStart;
  final DateTime dateFinish;
  final UserDatabaseEntity user;
  final RoutineEntity routine;
  final ExerciseEntity exercise;

  RoutineExerciseEntity({
    required this.idRoutineExercise,
    required this.dateStart,
    required this.dateFinish,
    required this.user,
    required this.routine,
    required this.exercise,
  });
}
