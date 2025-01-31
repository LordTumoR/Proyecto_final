import 'dart:convert';
import 'package:flutter_tracktrail_app/data/models/food_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class FoodDatabaseRemoteDataSource {
  Future<List<FoodModelDatabase>> getNutritionFoods(int dietId);
  Future<FoodModelDatabase> createFood(FoodModelDatabase food, int dietId);
  Future<FoodModelDatabase> updateFood(FoodModelDatabase food);
}

class FoodDatabaseRemoteDataSourceImpl implements FoodDatabaseRemoteDataSource {
  final http.Client client;

  FoodDatabaseRemoteDataSourceImpl(this.client);

  static const String baseUrl = 'http://localhost:8080';

  @override
  Future<List<FoodModelDatabase>> getNutritionFoods(int dietId) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');

    if (email == null) {
      throw Exception("Email no encontrado en SharedPreferences");
    }

    final userId = await _getUserIdByEmail(email);

    final response =
        await client.get(Uri.parse('$baseUrl/nutrition-records/user/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> nutritionRecords = json.decode(response.body);
      final List<FoodModelDatabase> foods = [];

      for (var record in nutritionRecords) {
        if (record['id'] == dietId) {
          final List<dynamic> nutritionFoodsJson =
              record['nutritionFoods'] as List<dynamic>;

          final filteredFoods = nutritionFoodsJson
              .map((json) => FoodModelDatabase.fromJson(json['food']))
              .toList();

          foods.addAll(filteredFoods);
        }
      }

      return foods;
    } else {
      throw Exception('Failed to load nutrition foods');
    }
  }

  @override
  Future<FoodModelDatabase> createFood(
      FoodModelDatabase food, int dietId) async {
    final createFoodUrl = Uri.parse('$baseUrl/foods');
    final headers = {'Content-Type': 'application/json'};
    final createFoodBody = json.encode(food.toJson());

    final createFoodResponse = await client.post(
      createFoodUrl,
      headers: headers,
      body: createFoodBody,
    );

    if (createFoodResponse.statusCode == 201) {
      final Map<String, dynamic> responseJson =
          json.decode(createFoodResponse.body);
      final createdFood = FoodModelDatabase.fromJson(responseJson);

      final addFoodToDietUrl =
          Uri.parse('$baseUrl/nutrition-records/$dietId/add-foods');
      final addFoodToDietBody = json.encode([
        {
          "foodId": createdFood.id,
          "amount": 0,
        }
      ]);

      final addFoodToDietResponse = await client.post(
        addFoodToDietUrl,
        headers: headers,
        body: addFoodToDietBody,
      );

      if (addFoodToDietResponse.statusCode == 201) {
        return createdFood;
      } else {
        throw Exception(
            'Failed to add food to diet: ${addFoodToDietResponse.statusCode}');
      }
    } else {
      throw Exception(
          'Failed to create food: ${createFoodResponse.statusCode}');
    }
  }

  Future<int> _getUserIdByEmail(String email) async {
    const String token = 'admin';
    final response = await client.get(
      Uri.parse('http://10.250.76.46:8080/users'),
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
  Future<FoodModelDatabase> updateFood(FoodModelDatabase food) async {
    final url = Uri.parse('$baseUrl/foods/${food.id}');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode(food.toJson());

    final response = await client.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = json.decode(response.body);
      return FoodModelDatabase.fromJson(responseJson);
    } else {
      throw Exception('Failed to update food: ${response.statusCode}');
    }
  }
}
