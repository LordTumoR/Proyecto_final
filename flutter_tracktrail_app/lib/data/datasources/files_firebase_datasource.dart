import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

abstract class FirebaseStorageDataSource {
  Future<List<Map<String, String>>> fetchImages();
  Future<String> uploadImage(dynamic file, String fileName);
  Future<void> deleteImage(String id);
  Future<void> saveRoutineWithImage(int routineId, String imageUrl);
}

class FirebaseStorageDataSourceImpl implements FirebaseStorageDataSource {
  final FirebaseStorage storage;

  FirebaseStorageDataSourceImpl({required this.storage});

  @override
  Future<List<Map<String, String>>> fetchImages() async {
    try {
      final ListResult result = await storage.ref().child('images').listAll();
      final images = await Future.wait(result.items.map((ref) async {
        final url = await ref.getDownloadURL();
        return {'id': ref.name, 'url': url};
      }));

      return images;
    } catch (e) {
      throw Exception('Error al cargar las imágenes: $e');
    }
  }

  @override
  Future<String> uploadImage(dynamic file, String fileName) async {
    try {
      final Reference storageRef = storage.ref().child('images/$fileName');

      if (kIsWeb) {
        // En el entorno web
        if (file is Uint8List) {
          await storageRef.putData(file);
          print('Subiendo archivo: $file');
          print('Tipo de archivo: ${file.runtimeType}');
        } else {
          throw Exception(
              'En entornos web, el fichero debe ser de tipo Uint8List');
        }
      } else {
        // En móviles/escritorio
        print('Subiendo archivo: $file');
        print('Tipo de archivo: ${file.runtimeType}');
        if (file is File) {
          final fileBytes = await file.readAsBytes();

          await storageRef.putData(fileBytes);
        } else if (file is String) {
          final fileBytes = File(file).readAsBytesSync();

          await storageRef.putData(fileBytes);
        } else {
          throw Exception(
              'En dispositivos móviles, el archivo debe ser de tipo File o String');
        }
      }

      final String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error al cargar la imagen: $e');
    }
  }

  @override
  Future<void> deleteImage(String id) async {
    try {
      final Reference storageRef = storage.ref().child('images/$id');
      await storageRef.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  @override
  Future<void> saveRoutineWithImage(int routineId, String imageUrl) async {
    try {
      final response = await http.put(
        Uri.parse('https://tracktrail.me/routines/$routineId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'imageurl': imageUrl,
        }),
      );

      if (response.statusCode == 201) {
        print('Rutina guardada exitosamente con la imagen');
      } else {
        throw Exception('Error guardando la rutina: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
