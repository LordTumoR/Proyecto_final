import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/core/failure.dart';
import 'package:flutter_tracktrail_app/core/use_case.dart';
import '../repositories/sign_in_repository.dart';

class RestorePasswordUseCase implements UseCase<void, ResetParamsNormal> {
  final SignInRepository repository;

  RestorePasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ResetParamsNormal params) async {
    return repository.restorePassword(params.email);
  }
}

class ResetParamsNormal {
  final String email;

  ResetParamsNormal({required this.email});
}
