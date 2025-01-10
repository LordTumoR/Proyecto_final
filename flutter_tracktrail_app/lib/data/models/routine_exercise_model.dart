import 'package:flutter_tracktrail_app/data/models/exercise_model.dart';
import 'package:flutter_tracktrail_app/data/models/routines_model.dart';
import 'package:flutter_tracktrail_app/data/models/user_database_model.dart';
import 'package:flutter_tracktrail_app/domain/entities/routine-exercise.dart';

class RoutineExerciseModel {
  final int idRoutineExercise;
  final DateTime dateStart;
  final DateTime dateFinish;
  final UserDatabaseModel user;
  final RoutineModel routines;
  final ExerciseModel ejercicios;
  final bool completion;

  RoutineExerciseModel({
    required this.idRoutineExercise,
    required this.dateStart,
    required this.dateFinish,
    required this.user,
    required this.routines,
    required this.ejercicios,
    required this.completion,
  });

  factory RoutineExerciseModel.fromJson(Map<String, dynamic> json) {
    return RoutineExerciseModel(
      idRoutineExercise: json['id_routine_exercise'],
      dateStart: json['date_start'] != null
          ? DateTime.parse(json['date_start'])
          : DateTime.now(),
      dateFinish: json['date_finish'] != null
          ? DateTime.parse(json['date_finish'])
          : DateTime.now(),
      user: UserDatabaseModel.fromJson(json['user']),
      routines: RoutineModel.fromJson(json['routines']),
      ejercicios: ExerciseModel.fromJson(json['ejercicios']),
      completion: json['completado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_routine_exercise': idRoutineExercise,
      'date_start': dateStart.toIso8601String(),
      'date_finish': dateFinish.toIso8601String(),
      'user': user.toJson(),
      'routines': routines.toJson(),
      'ejercicios': ejercicios.toJson(),
      'completion': completion,
    };
  }

  RoutineExerciseEntity toEntity() {
    return RoutineExerciseEntity(
      idRoutineExercise: idRoutineExercise,
      dateStart: dateStart,
      dateFinish: dateFinish,
      user: user.toEntity(),
      routine: routines.toEntity(),
      exercise: ejercicios.toEntity(),
      completion: completion,
    );
  }
}
