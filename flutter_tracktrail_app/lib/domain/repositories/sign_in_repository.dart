import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/core/failure.dart';
import 'package:flutter_tracktrail_app/data/models/user_model.dart';
import 'package:flutter_tracktrail_app/domain/entities/user_entity.dart';

abstract class SignInRepository {
  Future<Either<Failure, UserEntity>> signIn(String email, String password);
  Future<Either<Failure, UserEntity>> signInNormal(
      String email, String password);
  Future<Either<Failure, UserEntity>> register(String email, String password);
  Future<Either<Failure, String>> isLoggedIn();
  Future<Either<Failure, void>> logout();
}
