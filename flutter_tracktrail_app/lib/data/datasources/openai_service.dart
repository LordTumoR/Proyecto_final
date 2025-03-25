import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' show FirebaseStorage;
import 'package:flutter_tracktrail_app/core/sharedPreferences.dart';
import 'package:flutter_tracktrail_app/data/datasources/routine_exercises_datasource.dart';
import 'package:flutter_tracktrail_app/domain/entities/food_entity.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/exercises_display/date_manager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tracktrail_app/data/models/exercise_model.dart';
import 'package:image_picker/image_picker.dart';

class OpenAIService {
  final String apiKey = "";
  final String endpoint = "https://api.openai.com/v1/chat/completions";

  OpenAIService();
  Future<List<Map<String, dynamic>>> generarEjerciciosYGenerarJson(
      String muscleGroup, int cantidad) async {
    final fechaSeleccionada = DateManager().selectedDate.value;

    final prompt = """
      Eres un asistente experto en planificación de entrenamientos. 
      Genera $cantidad ejercicios para el grupo muscular "$muscleGroup" en formato JSON con la siguiente estructura, ademas Devuélveme solo un JSON plano, sin explicaciones ni formato Markdown. No pongas ```json ni ningún otro texto alrededor:
      [
        {
          "idExercise": null,
          "name": "Nombre del ejercicio",
          "description": "Descripción detallada del ejercicio",
          "image": "URL de una imagen ilustrativa",
          "dateTime": "${fechaSeleccionada}",
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
      final decodedUtf8Body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedUtf8Body);
      final rawContent = data['choices'][0]['message']['content'];
      print('Contenido IA (crudo):\n$rawContent');

      final cleanedContent =
          rawContent.replaceAll('```json', '').replaceAll('```', '').trim();

      try {
        final ejerciciosJson = jsonDecode(cleanedContent) as List<dynamic>;
        return ejerciciosJson.cast<Map<String, dynamic>>();
      } catch (e) {
        print("JSON inválido:\n$cleanedContent");
        throw Exception("Error al generar los ejercicios: $e");
      }
    } else {
      throw Exception("Error al generar ejercicios: ${response.body}");
    }
  }

  Future<List<FoodEntityDatabase>> analizarImagenYGuardarAlimentos(
      File imageFile) async {
    final fechaSeleccionada = DateManager().selectedDate.value;
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref =
          FirebaseStorage.instance.ref().child('imagenes_comida/$fileName.jpg');
      await ref.putFile(imageFile);
      final imageUrl = await ref.getDownloadURL();

      print("Imagen subida correctamente: $imageUrl");

      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "gpt-4o",
          "messages": [
            {
              "role": "user",
              "content": [
                {
                  "type": "text",
                  "text": "Analiza esta imagen y devuélveme en formato JSON una lista de los alimentos que ves. Usa esta estructura por cada alimento:\n\n"
                      "{\n"
                      "  \"name\": \"Nombre del alimento\",\n"
                      "  \"brand\": \"Marca si es visible, si no null\",\n"
                      "  \"category\": \"Categoría general (fruta, verdura, proteína, snack, etc)\",\n"
                      "  \"calories\": número o null,\n"
                      "  \"carbohydrates\": número o null,\n"
                      "  \"protein\": número o null,\n"
                      "  \"fat\": número o null,\n"
                      "  \"fiber\": número o null,\n"
                      "  \"sugar\": número o null,\n"
                      "  \"sodium\": número o null,\n"
                      "  \"cholesterol\": número o null,\n"
                      "  \"mealtype\": \"tipo de comida si lo sabes (desayuno, comida...) o null\",\n"
                      "  \"date\": \"Fecha estimada si es visible en el formato YYYY-MM-DDTHH:mm:ss\"\n"
                      "}\n\n"
                      "Solo responde con un JSON plano, sin explicaciones ni markdown."
                },
                {
                  "type": "image_url",
                  "image_url": {"url": "data:image/jpeg;base64,$base64Image"}
                }
              ]
            }
          ],
          "max_tokens": 1000,
        }),
      );

      if (response.statusCode != 200) {
        print("Error OpenAI: ${response.body}");
        return [];
      }

      final decodedBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedBody);
      final rawContent = data['choices'][0]['message']['content'];

      print("Respuesta de la IA:\n$rawContent");

      final cleaned =
          rawContent.replaceAll('```json', '').replaceAll('```', '').trim();
      final alimentosJson = jsonDecode(cleaned) as List<dynamic>;

      final alimentos = alimentosJson.map<FoodEntityDatabase>((json) {
        return FoodEntityDatabase(
          id: 0,
          name: json['name'] ?? 'Desconocido',
          brand: json['brand'] ?? '',
          category: json['category'] ?? '',
          calories: (json['calories'] as num?)?.toDouble(),
          carbohydrates: (json['carbohydrates'] as num?)?.toDouble(),
          protein: (json['protein'] as num?)?.toDouble(),
          fat: (json['fat'] as num?)?.toDouble(),
          fiber: (json['fiber'] as num?)?.toDouble(),
          sugar: (json['sugar'] as num?)?.toDouble(),
          sodium: (json['sodium'] as num?)?.toDouble(),
          cholesterol: (json['cholesterol'] as num?)?.toDouble(),
          mealtype: json['mealtype'],
          date: fechaSeleccionada,
        );
      }).toList();

      return alimentos;
    } catch (e) {
      print("Error analizando imagen y guardando alimentos: $e");
      return [];
    }
  }
}
