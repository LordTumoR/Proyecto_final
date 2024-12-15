import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/core/failure.dart';
import 'package:flutter_tracktrail_app/core/use_case.dart';
import 'package:flutter_tracktrail_app/domain/entities/user_entity.dart';
import '../repositories/sign_in_repository.dart';

class RegisterUserUseCase implements UseCase<void, RegisterParamsNormal> {
  final SignInRepository repository;
  RegisterUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParamsNormal params) async {
    return repository.register(params.email, params.password);
  }
}

class RegisterParamsNormal {
  final String email;
  final String password;
  RegisterParamsNormal({required this.email, required this.password});
}
