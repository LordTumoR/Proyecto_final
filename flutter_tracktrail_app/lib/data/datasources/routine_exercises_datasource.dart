import 'dart:convert';
import 'package:flutter_tracktrail_app/data/models/routine_exercise_model.dart';
import 'package:http/http.dart' as http;

abstract class RoutineExerciseRemoteDataSource {
  Future<List<RoutineExerciseModel>> getRoutineExercises();
  Future<List<RoutineExerciseModel>> getUserRoutines(String email);
}

class RoutineExerciseRemoteDataSourceImpl
    implements RoutineExerciseRemoteDataSource {
  final http.Client client;

  RoutineExerciseRemoteDataSourceImpl(this.client);

  @override
  Future<List<RoutineExerciseModel>> getRoutineExercises() async {
    const String token = 'admin';
    final response = await client.get(
      Uri.parse('http://192.168.1.138:8080/routine-exercises'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> routineExercisesJson = json.decode(response.body);
      return routineExercisesJson
          .map((json) => RoutineExerciseModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Error al cargar los ejercicios de rutina');
    }
  }

  @override
  Future<List<RoutineExerciseModel>> getUserRoutines(String email) async {
    final response = await client
        .get(Uri.parse('http://192.168.1.138:8080/routine-exercises'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      List<RoutineExerciseModel> routines = data
          .where((routine) => routine['user']['email'] == email)
          .map((routine) => RoutineExerciseModel.fromJson(routine))
          .toList();

      return routines;
    } else {
      throw Exception('Error al obtener las rutinas');
    }
  }
}
