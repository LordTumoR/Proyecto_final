import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class ProgressRemoteDataSource {
  Future<List<dynamic>> getEvolutionWeight(int exerciseId);
  Future<List<dynamic>> getEvolutionRepsSets(int exerciseId);
  Future<List<dynamic>> getPersonalRecords();
  Future<int> getTrainingStreak(int userId);
}

class ProgressRemoteDataSourceImpl implements ProgressRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'http://192.168.1.141:8080/progress';
  final String token = 'admin';

  ProgressRemoteDataSourceImpl(this.client);

  @override
  Future<List<dynamic>> getEvolutionWeight(int exerciseId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/evolution-weight/$exerciseId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener evolución de peso.');
    }
  }

  @override
  Future<List<dynamic>> getEvolutionRepsSets(int exerciseId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/evolution-reps-sets/$exerciseId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener evolución de repeticiones y sets.');
    }
  }

  @override
  Future<List<dynamic>> getPersonalRecords() async {
    final response = await client.get(
      Uri.parse('$baseUrl/personal-records'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener récords personales.');
    }
  }

  @override
  Future<int> getTrainingStreak(int userId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/training-streak/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['streak'];
    } else {
      throw Exception('Error al obtener la racha de entrenamiento.');
    }
  }
}
