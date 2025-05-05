import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProgressRemoteDataSource {
  Future<List<dynamic>> getEvolutionWeight(String muscleGroup);
  Future<List<dynamic>> getEvolutionRepsSets(String muscleGroup);
  Future<List<dynamic>> getPersonalRecords();
  Future<int> getTrainingStreak();
}

class ProgressRemoteDataSourceImpl implements ProgressRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://tracktrail.me/progress';
  final String token = 'admin';

  ProgressRemoteDataSourceImpl(this.client);

  @override
  Future<List<dynamic>> getEvolutionWeight(String muscleGroup) async {
    final response = await client.get(
      Uri.parse('$baseUrl/evolution-weight/$muscleGroup'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic>) {
        return [jsonResponse];
      } else if (jsonResponse is List) {
        return jsonResponse;
      } else {
        throw Exception("Respuesta inesperada del servidor");
      }
    } else {
      throw Exception('Error al obtener evolución de peso.');
    }
  }

  @override
  Future<List<dynamic>> getEvolutionRepsSets(String muscleGroup) async {
    final response = await client.get(
      Uri.parse('$baseUrl/evolution-reps-sets/$muscleGroup'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic>) {
        return [jsonResponse];
      } else if (jsonResponse is List) {
        return jsonResponse;
      } else {
        throw Exception("Respuesta inesperada del servidor");
      }
    } else {
      throw Exception('Error al obtener evolución de peso.');
    }
  }

  @override
  Future<List<dynamic>> getPersonalRecords() async {
    final response = await client.get(
      Uri.parse('$baseUrl/personal-records'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic>) {
        return [jsonResponse];
      } else if (jsonResponse is List) {
        return jsonResponse;
      } else {
        throw Exception("Respuesta inesperada del servidor");
      }
    } else {
      throw Exception('Error al obtener evolución de peso.');
    }
  }

  @override
  Future<int> getTrainingStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');

    if (email == null) {
      throw Exception("Email no encontrado en SharedPreferences");
    }

    final userId = await _getUserIdByEmail(email);
    final response = await client.get(
      Uri.parse('$baseUrl/training-streak/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      try {
        final streak = int.parse(response.body);
        return streak;
      } catch (e) {
        throw Exception('Error al convertir la respuesta en un número: $e');
      }
    } else {
      throw Exception(
          'Error al obtener la racha de entrenamiento. Código: ${response.statusCode}');
    }
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
}
