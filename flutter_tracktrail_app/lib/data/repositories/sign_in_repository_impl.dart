import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/core/failure.dart';
import 'package:flutter_tracktrail_app/data/datasources/firebase_auth_datasource.dart';
import 'package:flutter_tracktrail_app/data/models/user_model.dart';
import 'package:flutter_tracktrail_app/domain/entities/user_entity.dart';
import 'package:flutter_tracktrail_app/domain/repositories/sign_in_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInRepositoryImpl implements SignInRepository {
  final FirebaseAuthDataSource dataSource;
  final SharedPreferences sharedPreferences;

  SignInRepositoryImpl(this.dataSource, this.sharedPreferences);

  @override
  Future<Either<Failure, UserEntity>> signIn(
      String email, String password) async {
    try {
      UserModel user = await dataSource.signInWithGoogle();

      await sharedPreferences.setString('email', user.email);

      return Right(user.toEntity());
    } catch (e) {
      print(e);
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInNormal(
      String email, String password) async {
    try {
      UserModel user = await dataSource.signIn(email, password);

      await sharedPreferences.setString('email', user.email);

      return Right(user.toEntity());
    } catch (e) {
      print(e);
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
      String email, String password) async {
    try {
      UserModel user = await dataSource.register(email, password);

      await sharedPreferences.setString('email', user.email);

      return Right(user.toEntity());
    } catch (e) {
      print(e);
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, String>> isLoggedIn() async {
    try {
      String? user = dataSource.getCurrentUser();
      return Right(user ?? "NO_USER");
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await dataSource.logout();

      await sharedPreferences.remove('email');

      return const Right(null);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> restorePassword(
    String email,
  ) async {
    try {
      await dataSource.restorePassword(email);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure());
    }
  }
}
