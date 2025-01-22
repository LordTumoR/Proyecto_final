import 'dart:convert';
import 'package:flutter_tracktrail_app/core/sharedPreferences.dart';
import 'package:flutter_tracktrail_app/data/models/user_database_model.dart';
import 'package:http/http.dart' as http;

abstract class UserRemoteDataSource {
  Future<UserDatabaseModel> getUsers();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl(this.client);

  @override
  Future<UserDatabaseModel> getUsers() async {
    final email = await PreferencesHelper.getEmailFromPreferences();
    final userId = await _getUserIdByEmail(email!);
    if (userId == null) {
      throw Exception("El id_user no fue encontrado.");
    }
    const String token = 'admin';
    final response = await client.get(
      Uri.parse('http://192.168.1.144:8080/users/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = json.decode(response.body);
      return UserDatabaseModel.fromJson(decodedResponse);
    } else {
      throw Exception('Error al cargar el usuario');
    }
  }

  Future<int> _getUserIdByEmail(String email) async {
    const String token = 'admin';
    final response = await client.get(
      Uri.parse('http://192.168.1.144:8080/users'),
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
