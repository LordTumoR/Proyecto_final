import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/core/failure.dart';
import 'package:flutter_tracktrail_app/core/use_case.dart';
import 'package:flutter_tracktrail_app/domain/entities/user_entity.dart';
import '../repositories/sign_in_repository.dart';

class SigninNormalUserUseCase implements UseCase<void, LoginParamsNormal> {
  final SignInRepository repository;
  SigninNormalUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParamsNormal params) async {
    return repository.signInNormal(params.email, params.password);
  }
}

class LoginParamsNormal {
  final String email;
  final String password;
  LoginParamsNormal({required this.email, required this.password});
}
