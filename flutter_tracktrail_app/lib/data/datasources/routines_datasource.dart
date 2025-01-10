import 'dart:convert';
import 'package:flutter_tracktrail_app/core/sharedPreferences.dart';
import 'package:flutter_tracktrail_app/data/models/routines_model.dart';
import 'package:http/http.dart' as http;

abstract class RoutineRemoteDataSource {
  Future<List<RoutineModel>> getRoutines();
  Future<void> deleteRoutine(int idRoutine);
  Future<RoutineModel> createRoutine(
    String? name,
    String? goal,
    int? duration,
    bool? isPrivate,
    String? difficulty,
    String? progress,
    int? routineId,
  );
  Future<List<RoutineModel>> getRoutinesByUserEmail(String email);
  Future<double> getCompletion(int routineId);
}

class RoutineRemoteDataSourceImpl implements RoutineRemoteDataSource {
  final http.Client client;

  RoutineRemoteDataSourceImpl(this.client);

  @override
  Future<List<RoutineModel>> getRoutines() async {
    const String token = 'admin';
    final response = await client.get(
      Uri.parse('http://10.250.79.59:8080/routines'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> routinesJson = json.decode(response.body);
      return routinesJson.map((json) => RoutineModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar rutinas');
    }
  }

  @override
  Future<List<RoutineModel>> getRoutinesByUserEmail(String email) async {
    int? userId;

    if (email.isNotEmpty) {
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

    final allRoutines = await getRoutines();

    final userRoutines = allRoutines.where((routine) {
      return routine.idUser != null && routine.idUser!.idUser == userId;
    }).toList();

    if (userRoutines.isEmpty) {}

    return userRoutines;
  }

  @override
  Future<RoutineModel> createRoutine(
    String? name,
    String? goal,
    int? duration,
    bool? isPrivate,
    String? difficulty,
    String? progress,
    int? routineId,
  ) async {
    const String token = 'admin';

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

    if (routineId != null && routineId != 0) {
      final response = await client.put(
        Uri.parse('http://10.250.79.59:8080/routines/$routineId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          if (name?.isNotEmpty ?? false) 'name': name,
          if (goal?.isNotEmpty ?? false) 'goal': goal,
          if (duration != 0) 'duration': duration,
          if (isPrivate != null) 'private_public': isPrivate,
          if (difficulty?.isNotEmpty ?? false) 'dificulty': difficulty,
          if (progress?.isNotEmpty ?? false) 'progress': progress,
          'id_user': userId,
        }),
      );

      if (response.statusCode == 200) {
        final routine = RoutineModel.fromJson(json.decode(response.body));
        return routine;
      } else {
        throw Exception(
            'Error al actualizar la rutina: ${response.statusCode}');
      }
    } else {
      final response = await client.post(
        Uri.parse('http://10.250.79.59:8080/routines'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'goal': goal,
          'duration': duration,
          'private_public': isPrivate,
          'dificulty': difficulty,
          'progress': progress,
          'id_user': userId,
        }),
      );

      if (response.statusCode == 201) {
        final routine = RoutineModel.fromJson(json.decode(response.body));
        return routine;
      } else {
        throw Exception('Error al crear la rutina: ${response.statusCode}');
      }
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

  @override
  Future<void> deleteRoutine(int idRoutine) async {
    const String token = 'admin';
    final response = await client.delete(
      Uri.parse('http://10.250.79.59:8080/routines/$idRoutine'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar rutina con id $idRoutine');
    }
  }

  @override
  Future<double> getCompletion(int routineId) async {
    const String token = 'admin';
    final response = await client.get(
      Uri.parse(
          'http://10.250.79.59:8080/routine-exercises/$routineId/completion'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> completionJson = json.decode(response.body);
      return completionJson['percentage'];
    } else {
      throw Exception('Error al obtener el porcentaje de completado');
    }
  }
}
