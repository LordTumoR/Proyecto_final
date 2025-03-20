import 'dart:convert';
import 'package:flutter_tracktrail_app/core/sharedPreferences.dart';
import 'package:flutter_tracktrail_app/data/datasources/routine_exercises_datasource.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tracktrail_app/data/models/exercise_model.dart';

class OpenAIService {
  final String apiKey = "";
  final String endpoint = "https://api.openai.com/v1/chat/completions";

  OpenAIService();
  Future<List<Map<String, dynamic>>> generarEjerciciosYGenerarJson(
      String muscleGroup, int cantidad) async {
    final prompt = """
      Eres un asistente experto en planificación de entrenamientos. 
      Genera $cantidad ejercicios para el grupo muscular "$muscleGroup" en formato JSON con la siguiente estructura:
      [
        {
          "idExercise": null,
          "name": "Nombre del ejercicio",
          "description": "Descripción detallada del ejercicio",
          "image": "URL de una imagen ilustrativa",
          "dateTime": "${DateTime.now().toIso8601String()}",
          "repetitions": número de repeticiones recomendado,
          "weight": peso recomendado en kg (si aplica, si no 0),
          "muscleGroup": "$muscleGroup",
          "sets": número de series recomendado
        }
      ]
      No agregues explicaciones, solo responde con el JSON.
    """;

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content":
                "Eres un asistente experto en planificación de entrenamientos."
          },
          {"role": "user", "content": prompt}
        ],
        "max_tokens": 500,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final ejerciciosJson =
          jsonDecode(data['choices'][0]['message']['content']) as List;

      return ejerciciosJson
          .cast<Map<String, dynamic>>(); // Return the JSON data
    } else {
      throw Exception("Error al generar ejercicios: ${response.body}");
    }
  }
}
