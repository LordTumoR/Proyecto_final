import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tracktrail_app/data/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

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
      print("Correo de restablecimiento enviado a $email");
    } on FirebaseAuthException catch (e) {
      print("Error al intentar restablecer la contraseña: ${e.message}");
      throw Exception(e.message);
    }
  }

  Future<UserModel> register(String email, String password) async {
    try {
      UserCredential userCredentials = await auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final response = await http.post(
        Uri.parse('http://192.168.1.138:8080/users'),
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

  Future<void> logout() async {
    await auth.signOut();
  }

  String? getCurrentUser() {
    final user = auth.currentUser;
    return user?.email;
  }
}
