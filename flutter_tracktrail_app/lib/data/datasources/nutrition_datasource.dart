import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_tracktrail_app/data/models/nutrition_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NutritionRemoteDataSource {
  Future<List<NutritionModel>> getNutritionRecords();
  Future<void> deleteNutritionRecord(int id);
  Future<NutritionModel> createNutritionRecord(
    String name,
    String description,
    DateTime date,
    int userId,
  );
  Future<NutritionModel> updateNutritionRecord(
    int? id,
    String? name,
    String? description,
    DateTime? date,
    int? userId,
  );
}

class NutritionRemoteDataSourceImpl implements NutritionRemoteDataSource {
  final http.Client client;

  NutritionRemoteDataSourceImpl(this.client);

  static const String baseUrl =
      'http://192.168.1.138:8080/nutrition-records/user/';
  static const String CreateUrl = 'http://192.168.1.138:8080/nutrition-records';

  @override
  Future<List<NutritionModel>> getNutritionRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');

    if (email == null) {
      throw Exception("Email no encontrado en SharedPreferences");
    }

    final userId = await _getUserIdByEmail(email);
    final response = await client.get(Uri.parse('$baseUrl$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> nutritionJson = json.decode(response.body);
      return nutritionJson
          .map((json) => NutritionModel.fromJson(json))
          .toList();
    } else {
      throw Exception('SIN DIETAS');
    }
  }

  @override
  Future<void> deleteNutritionRecord(int id) async {
    final response = await client.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete nutrition record');
    }
  }

  Future<int> _getUserIdByEmail(String email) async {
    const String token = 'admin';
    final response = await client.get(
      Uri.parse('http://192.168.1.138:8080/users'),
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
  Future<NutritionModel> createNutritionRecord(
    String name,
    String description,
    DateTime date,
    int userId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');

      if (email == null) {
        throw Exception("Email no encontrado en SharedPreferences");
      }

      final userId = await _getUserIdByEmail(email);

      final response = await client.post(
        Uri.parse(CreateUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'description': description,
          'date': date.toIso8601String(),
          'user_id': userId,
        }),
      );

      if (response.statusCode == 201) {
        return NutritionModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create nutrition record');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to create nutrition record');
    }
  }

  @override
  Future<NutritionModel> updateNutritionRecord(
    int? id,
    String? name,
    String? description,
    DateTime? date,
    int? userId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');

      if (email == null) {
        throw Exception("Email no encontrado en SharedPreferences");
      }

      final userId = await _getUserIdByEmail(email);

      final response = await client.put(
        Uri.parse('$CreateUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'description': description,
          'date': date?.toIso8601String(),
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        return NutritionModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update nutrition record');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to update nutrition record');
    }
  }
}
