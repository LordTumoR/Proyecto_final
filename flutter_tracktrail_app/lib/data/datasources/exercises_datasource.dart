import 'dart:convert';
import 'package:flutter_tracktrail_app/data/models/exercise_model.dart';
import 'package:http/http.dart' as http;

abstract class ExerciseRemoteDataSource {
  Future<List<ExerciseModel>> getexercises();
  Future<void> deleteexercise(int idexercise);
}

class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final http.Client client;

  ExerciseRemoteDataSourceImpl(this.client);

  @override
  Future<List<ExerciseModel>> getexercises() async {
    const String token = 'admin';
    final response = await client.get(
      Uri.parse('http://192.168.53.228:8080/exercises'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> exercisesJson = json.decode(response.body);
      return exercisesJson.map((json) => ExerciseModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar rutinas');
    }
  }

  @override
  Future<void> deleteexercise(int idexercise) async {
    const String token = 'admin';
    final response = await client.delete(
      Uri.parse('http://192.168.53.228:8080/exercises/$idexercise'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el ejercicio con id $idexercise');
    }
  }
}
