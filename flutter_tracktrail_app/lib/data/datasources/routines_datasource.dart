import 'dart:convert';
import 'package:flutter_tracktrail_app/data/models/routines_model.dart';
import 'package:http/http.dart' as http;

abstract class RoutineRemoteDataSource {
  Future<List<RoutineModel>> getRoutines();
  Future<void> deleteRoutine(int idRoutine);
}

class RoutineRemoteDataSourceImpl implements RoutineRemoteDataSource {
  final http.Client client;

  RoutineRemoteDataSourceImpl(this.client);

  @override
  Future<List<RoutineModel>> getRoutines() async {
    const String token = 'admin';
    final response = await client.get(
      Uri.parse('http://192.168.1.138:8080/routines'),
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
  Future<void> deleteRoutine(int idRoutine) async {
    const String token = 'admin';
    final response = await client.delete(
      Uri.parse('http://192.168.1.138:8080/routines/$idRoutine'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar rutina con id $idRoutine');
    }
  }
}
