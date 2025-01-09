import 'dart:convert';
import 'package:flutter_tracktrail_app/core/sharedPreferences.dart';
import 'package:flutter_tracktrail_app/data/models/exercise_model.dart';
import 'package:flutter_tracktrail_app/data/models/routine_exercise_model.dart';
import 'package:http/http.dart' as http;

abstract class RoutineExerciseRemoteDataSource {
  Future<void> addExerciseToRoutine(int routineId, ExerciseModel newExercise);
  Future<List<RoutineExerciseModel>> getAllRoutineExercises();
  Future<ExerciseModel> createExercise(ExerciseModel exercise);
}

class RoutineExerciseRemoteDataSourceImpl
    implements RoutineExerciseRemoteDataSource {
  final http.Client client;

  RoutineExerciseRemoteDataSourceImpl(this.client);

  @override
  Future<ExerciseModel> createExercise(ExerciseModel exercise) async {
    const String token = 'admin';
    final response;

    if (exercise.idExercise == 0 || exercise.idExercise == null) {
      response = await client.post(
        Uri.parse('http://10.250.79.59:8080/exercises'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(exercise.toJson()),
      );
    } else {
      response = await client.put(
        Uri.parse('http://10.250.79.59:8080/exercises/${exercise.idExercise}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(exercise.toJson()),
      );
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> exerciseJson = json.decode(response.body);
      return ExerciseModel.fromJson(exerciseJson);
    } else {
      throw Exception(
          'Error al ${exercise.idExercise == 0 || exercise.idExercise == null ? 'crear' : 'actualizar'} el ejercicio');
    }
  }

  @override
  Future<List<RoutineExerciseModel>> getAllRoutineExercises() async {
    const String token = 'admin';
    final response = await client.get(
      Uri.parse('http://10.250.79.59:8080/routine-exercises'),
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
  Future<void> addExerciseToRoutine(
      int routineId, ExerciseModel newExercise) async {
    if (newExercise.idExercise != null && newExercise.idExercise != 0) {
      try {
        await createExercise(newExercise);
      } catch (e) {
        throw Exception('Error al actualizar el ejercicio: $e');
      }
      return;
    }

    final email = await PreferencesHelper.getEmailFromPreferences();
    int? userId;

    if (email != null && email.isNotEmpty) {
      try {
        userId = await _getUserIdByEmail(email);
        if (userId == null) {
          throw Exception("El id_user no fue encontrado.");
        }
      } catch (e) {
        throw Exception("Error al obtener el id del usuario.");
      }
    } else {
      throw Exception("No se encontró el email del usuario.");
    }

    try {
      final createdExercise = await createExercise(newExercise);

      final allRoutineExercises = await getAllRoutineExercises();

      final routineExercises = allRoutineExercises
          .where((routineExercise) =>
              routineExercise.routines.idRoutine == routineId)
          .toList();

      if (routineExercises.isEmpty) {
        final data = {
          "id_routine": routineId,
          "id_user": userId,
          "id_exercise": createdExercise.idExercise,
        };

        await insertRoutineExercise(data);
      }
      if (routineExercises.isNotEmpty) {
        final routineExerciseData = {
          "id_user": userId,
          "id_routine": routineId,
          "id_exercise": createdExercise.idExercise,
        };

        await insertRoutineExercise(routineExerciseData);
      }
    } catch (e) {
      throw Exception('Error al agregar ejercicio a la rutina: $e');
    }
  }

  Future<void> insertRoutineExercise(
      Map<String, dynamic> routineExercise) async {
    const String token = 'admin';
    final response = await client.post(
      Uri.parse('http://10.250.79.59:8080/routine-exercises'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(routineExercise),
    );

    if (response.statusCode != 201) {
      throw Exception(
          'Error al insertar el ejercicio en routine_exercises: ${response.body}');
    }
  }

  Future<int> _getUserIdByEmail(String email) async {
    const String token = 'admin';
    final response = await client.get(
      Uri.parse('http://10.250.79.59:8080/users'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> usersJson = json.decode(response.body);
      final user = usersJson.firstWhere(
        (userJson) => userJson['email'] == email,
        orElse: () => null,
      );

      if (user != null) {
        return user['id_user'];
      } else {
        throw Exception("Usuario no encontrado para el email $email");
      }
    } else {
      throw Exception('Error al obtener los usuarios');
    }
  }
}
