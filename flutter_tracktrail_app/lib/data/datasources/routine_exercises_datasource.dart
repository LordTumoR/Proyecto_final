import 'dart:convert';
import 'package:flutter_tracktrail_app/core/sharedPreferences.dart';
import 'package:flutter_tracktrail_app/data/models/exercise_model.dart';
import 'package:flutter_tracktrail_app/data/models/routine_exercise_model.dart';
import 'package:http/http.dart' as http;

abstract class RoutineExerciseRemoteDataSource {
  Future<void> addExerciseToRoutine(int routineId, ExerciseModel newExercise);
  Future<List<RoutineExerciseModel>> getAllRoutineExercises();
  Future<List<ExerciseModel>> createExercise(
      ExerciseModel exercise, int routineId, int userId);
  Future<void> updateRoutineExerciseCompletion(
      int routineExerciseId, bool isCompleted);
}

class RoutineExerciseRemoteDataSourceImpl
    implements RoutineExerciseRemoteDataSource {
  final http.Client client;

  RoutineExerciseRemoteDataSourceImpl(this.client);

  Future<List<ExerciseModel>> createExercise(
      ExerciseModel exercise, int routineId, int userId) async {
    const String token = 'admin';
    final response;

    if (exercise.idExercise == 0 || exercise.idExercise == null) {
      response = await client.post(
        Uri.parse('https://tracktrail.me/exercises/$routineId/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(exercise.toJson()),
      );
    } else {
      response = await client.put(
        Uri.parse('https://tracktrail.me/exercises/${exercise.idExercise}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(exercise.toJson()),
      );
    }

    if (response.statusCode == 201) {
      final List<dynamic> decodedResponse = json.decode(response.body);
      return decodedResponse
          .map((json) => ExerciseModel.fromJson(json))
          .toList();
    } else if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = json.decode(response.body);
      return [ExerciseModel.fromJson(decodedResponse)];
    } else {
      throw Exception(
          'Error al ${exercise.idExercise == 0 || exercise.idExercise == null ? 'crear' : 'actualizar'} el ejercicio');
    }
  }

  @override
  Future<List<RoutineExerciseModel>> getAllRoutineExercises() async {
    const String token = 'admin';
    final response = await client.get(
      Uri.parse('https://tracktrail.me/routine-exercises'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
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
      await createExercise(newExercise, routineId, userId);
    } catch (e) {
      throw Exception('Error al actualizar el ejercicio: $e');
    }
    return;
  }

  Future<int> _getUserIdByEmail(String email) async {
    const String token = 'admin';
    final response = await client.get(
      Uri.parse('https://tracktrail.me/users'),
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

  @override
  Future<void> updateRoutineExerciseCompletion(
      int routineExerciseId, bool isCompleted) async {
    const String token = 'admin';
    final url =
        'https://tracktrail.me/routine-exercises/$routineExerciseId';

    try {
      final response = await client.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'completado': isCompleted}),
      );

      if (response.statusCode == 200) {
      } else {
        throw Exception('Error updating routine exercise: ${response.body}');
      }
    } catch (error) {
      throw Exception('Failed to update routine exercise.');
    }
  }
}
