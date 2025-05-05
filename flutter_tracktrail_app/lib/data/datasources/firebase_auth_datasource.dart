import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tracktrail_app/data/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth auth;

  FirebaseAuthDataSource({required this.auth});

  Future<UserModel> signIn(String email, String password) async {
    UserCredential userCredentials =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return UserModel.fromUserCredential(userCredentials);
  }

  Future<void> restorePassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<UserModel> register(String email, String password) async {
    try {
      UserCredential userCredentials = await auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final response = await http.post(
        Uri.parse('https://tracktrail.me/users'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception(
            'Error al registrar el usuario en la base de datos: ${response.body}');
      }
      return UserModel.fromUserCredential(userCredentials);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Este correo ya está registrado.');
      } else if (e.code == 'weak-password') {
        throw Exception('La contraseña es demasiado débil.');
      } else {
        throw Exception('Error al registrar: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error inesperado: ${e.toString()}');
    }
  }

  Future<UserModel> signInWithGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      UserCredential userCredentials =
          await auth.signInWithPopup(googleProvider);
      return UserModel.fromUserCredential(userCredentials);
    } else {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredentials =
          await auth.signInWithCredential(credential);
      return UserModel.fromUserCredential(userCredentials);
    }
  }

  Future<void> updateUser(
    String email,
    String? name,
    String? surname,
    String? password,
    double? weight,
    DateTime? dateOfBirth,
    String? sex,
    double? height,
    String? avatar,
  ) async {
    final userId = await _getUserIdByEmail(email);
    if (userId == null) {
      throw Exception("El id_user no fue encontrado.");
    }

    final Map<String, dynamic> body = {};

    if (name != null && name.isNotEmpty) body['name'] = name;
    if (surname != null && surname.isNotEmpty) body['surname'] = surname;
    if (password != null && password.isNotEmpty) body['password'] = password;
    if (weight != null && weight > 0.0) body['weight'] = weight;

    if (dateOfBirth != null) {
      // Convierte la fecha de nacimiento al formato 'YYYY-MM-DDTHH:mm:ss.sss'
      // Si no necesitas la hora exacta, puedes ponerla a las 00:00:00.000
      String formattedDate = dateOfBirth
          .toIso8601String(); // Esto da el formato 'YYYY-MM-DDTHH:mm:ss.sssZ'
      body['dateOfBirth'] = formattedDate; // Incluye la fecha con la hora
    }

    if (sex != null && sex.isNotEmpty) body['sex'] = sex;
    if (height != null && height > 0.0) body['height'] = height;
    if (avatar != null && avatar.isNotEmpty) body['avatar'] = avatar;

    final response = await http.put(
      Uri.parse('https://tracktrail.me/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Error al actualizar el usuario en la base de datos: ${response.body}',
      );
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isRegistered = prefs.getBool('isRegistered');
    if (isRegistered != null && isRegistered) {
      await prefs.remove('isRegistered');
    } else {}
  }

  Future<int> _getUserIdByEmail(String email) async {
    const String token = 'admin';
    final response = await http.get(
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

  Future<void> logout() async {
    await auth.signOut();
  }

  String? getCurrentUser() {
    final user = auth.currentUser;
    return user?.email;
  }
}
