import 'dart:convert';
import 'package:flutter_tracktrail_app/core/sharedPreferences.dart';
import 'package:flutter_tracktrail_app/data/models/routines_model.dart';
import 'package:http/http.dart' as http;

abstract class RoutineRemoteDataSource {
  Future<List<RoutineModel>> getRoutines();
  Future<void> deleteRoutine(int idRoutine);
  Future<RoutineModel> createRoutine(
    String name,
    String goal,
    int duration,
    bool isPrivate,
    String difficulty,
    String progress,
  );
  Future<List<RoutineModel>> getRoutinesByUserEmail(String email);
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
        print(userId);
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

    final allRoutines = await getRoutines();
    print('Todas las rutinas: $allRoutines');

    final userRoutines = allRoutines.where((routine) {
      return routine.idUser != null && routine.idUser!.idUser == userId;
    }).toList();

    if (userRoutines.isEmpty) {
      print("No se encontraron rutinas para el usuario con id $userId");
    }

    return userRoutines;
  }

  @override
  Future<RoutineModel> createRoutine(
    String name,
    String goal,
    int duration,
    bool isPrivate,
    String difficulty,
    String progress,
  ) async {
    const String token = 'admin';

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

      print("Rutina creada correctamente y vinculada al usuario.");
      return routine;
    } else {
      print('Error al crear la rutina: ${response.body}');
      throw Exception('Error al crear la rutina: ${response.statusCode}');
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
}
