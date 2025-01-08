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
    final response = await client.post(
      Uri.parse('http://10.250.79.59:8080/exercises'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(exercise.toJson()),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> exerciseJson = json.decode(response.body);
      return ExerciseModel.fromJson(exerciseJson);
    } else {
      throw Exception('Error al crear el ejercicio');
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
    final email = await PreferencesHelper.getEmailFromPreferences();
    int? userId;

    if (email != null && email.isNotEmpty) {
      try {
        userId = await _getUserIdByEmail(email);
        if (userId == null) {
          print("El id_user no fue encontrado.");
          throw Exception("El id_user no fue encontrado.");
        }
      } catch (e) {
        print("Error al obtener el id del usuario por email: $e");
        throw Exception("Error al obtener el id del usuario.");
      }
    } else {
      print("No se encontró el email del usuario.");
      throw Exception("No se encontró el email del usuario.");
    }

    try {
      final createdExercise = await createExercise(newExercise);
      print('Ejercicio a insertar: $createdExercise');

      final allRoutineExercises = await getAllRoutineExercises();
      print('Todas las rutinas-ejercicios: $allRoutineExercises');

      final routineExercises = allRoutineExercises
          .where((routineExercise) =>
              routineExercise.routines.idRoutine == routineId)
          .toList();
      print('Rutinas con ejercicio (filtradas por ID): $routineExercises');

      if (routineExercises.isEmpty) {
        print("La rutina no existe. Creando la rutina en routine_exercises...");

        final data = {
          "id_routine": routineId,
          "id_user": userId,
          "id_exercise": createdExercise.idExercise,
        };

        print("Datos para insertar rutina en routine_exercises: $data");

        await insertRoutineExercise(data);
      }
      if (routineExercises.isNotEmpty) {
        final routineExerciseData = {
          "id_user": userId,
          "id_routine": routineId,
          "id_exercise": createdExercise.idExercise,
        };

        print(
            "Datos para insertar ejercicio en routine_exercises: $routineExerciseData");
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
      print('Error al obtener usuarios: ${response.body}');
      throw Exception('Error al obtener los usuarios');
    }
  }
}
