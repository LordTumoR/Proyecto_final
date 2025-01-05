import 'package:flutter_tracktrail_app/data/models/exercise_model.dart';
import 'package:flutter_tracktrail_app/data/models/routines_model.dart';
import 'package:flutter_tracktrail_app/data/models/user_database_model.dart';

class RoutineExerciseModel {
  final int idRoutineExercise;
  final DateTime dateStart;
  final DateTime dateFinish;
  final UserDatabaseModel user;
  final RoutineModel routines;
  final ExerciseModel ejercicios;

  RoutineExerciseModel({
    required this.idRoutineExercise,
    required this.dateStart,
    required this.dateFinish,
    required this.user,
    required this.routines,
    required this.ejercicios,
  });

  factory RoutineExerciseModel.fromJson(Map<String, dynamic> json) {
    return RoutineExerciseModel(
      idRoutineExercise: json['id_routine_exercise'],
      dateStart: DateTime.parse(json['date_start']),
      dateFinish: DateTime.parse(json['date_finish']),
      user: UserDatabaseModel.fromJson(json['user']),
      routines: RoutineModel.fromJson(json['routines']),
      ejercicios: ExerciseModel.fromJson(json['ejercicios']),
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
    };
  }
}
