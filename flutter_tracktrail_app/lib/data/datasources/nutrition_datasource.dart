import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
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
    String imageUrl,
  );
  Future<NutritionModel> updateNutritionRecord(
    int? id,
    String? name,
    String? description,
    DateTime? date,
    int? userId,
    String? imageUrl,
    bool? isFavorite,
  );
}

class NutritionRemoteDataSourceImpl implements NutritionRemoteDataSource {
  final http.Client client;

  NutritionRemoteDataSourceImpl(this.client);
  static const String deleteurl = 'https://tracktrail.me/nutrition-records';
  static const String baseUrl =
      'https://tracktrail.me/nutrition-records/user/';
  static const String createUrl = 'https://tracktrail.me/nutrition-records';

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
    final response = await client.delete(Uri.parse('$deleteurl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete nutrition record');
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

  @override
  Future<NutritionModel> createNutritionRecord(
    String name,
    String description,
    DateTime date,
    int userId,
    String imageUrl,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');

      if (email == null) {
        throw Exception("Email no encontrado en SharedPreferences");
      }

      final userIdd = await _getUserIdByEmail(email);

      final response = await client.post(
        Uri.parse(createUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'description': description,
          'date': date.toIso8601String(),
          'user_id': userIdd,
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
    dynamic imageFile,
    bool? isFavorite,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');

      if (email == null) {
        throw Exception("Email no encontrado en SharedPreferences");
      }

      final userId = await _getUserIdByEmail(email);

      String? imageUrl;

      // Verificar si se ha recibido un archivo de imagen
      if (imageFile != null) {
        // Si es una ruta de archivo (String), convertirla a File
        File imageFileObject;
        if (imageFile is String) {
          imageFileObject = File(imageFile); // Convertir la ruta en un archivo
        } else if (imageFile is File) {
          imageFileObject = imageFile; // Ya es un archivo
        } else {
          throw Exception("Tipo de archivo no válido");
        }

        // Crear un nombre único para la imagen usando la fecha actual
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final ref = FirebaseStorage.instance
            .ref()
            .child('imagenes_comida/$fileName.jpg');

        // Subir el archivo a Firebase Storage
        await ref.putFile(imageFileObject);

        // Obtener la URL de descarga del archivo subido
        imageUrl = await ref.getDownloadURL();
        print("Imagen subida correctamente: $imageUrl");
      }

      // Hacer la petición PUT para actualizar el registro de nutrición
      final Map<String, dynamic> requestBody = {};

      if (name != null) requestBody['name'] = name;
      if (description != null) requestBody['description'] = description;
      if (date != null) requestBody['date'] = date?.toIso8601String();
      if (userId != null) requestBody['user_id'] = userId;
      if (imageUrl != null) requestBody['imageurl'] = imageUrl;
      if (isFavorite != null) requestBody['isFavorite'] = isFavorite;

      final response = await client
          .put(
            Uri.parse('$createUrl/$id'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(requestBody),
          )
          .timeout(Duration(seconds: 10));

      // Verificar la respuesta del servidor
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NutritionModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update nutrition record: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to update nutrition record');
    }
  }
}
