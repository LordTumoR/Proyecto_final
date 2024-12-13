import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/core/failure.dart';
import 'package:flutter_tracktrail_app/core/use_case.dart';
import 'package:flutter_tracktrail_app/domain/entities/user_entity.dart';
import '../repositories/sign_in_repository.dart';

class SigninUserUseCase implements UseCase<void, LoginParams> {
  final SignInRepository repository;
  SigninUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    return repository.signIn(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;
  LoginParams({required this.email, required this.password});
}
