import 'package:flutter_tracktrail_app/core/use_case.dart';
import 'package:flutter_tracktrail_app/domain/entities/user_database_entity.dart';
import 'package:flutter_tracktrail_app/domain/repositories/sign_in_repository.dart';

class UpdateUserInDatabaseUseCase implements UseCase<void, UserParams> {
  final SignInRepository userRepository;

  UpdateUserInDatabaseUseCase(this.userRepository);

  @override
  Future<void> call(UserParams params) async {
    final userEntity = UserDatabaseEntity(
      id: 0,
      name: params.name ?? '',
      surname: params.surname ?? '',
      email: params.email,
      password: params.password ?? '',
      weight: params.weight ?? 0.0,
      dateOfBirth: params.dateOfBirth ?? DateTime(2000, 1, 1),
      sex: params.sex ?? '',
      height: params.height ?? 0.0,
      role: 1,
      avatar: params.avatar ?? '',
    );

    await userRepository.updateUserByEmail(userEntity);
  }
}

class UserParams {
  final String email;
  final String? name;
  final String? surname;
  final String? password;
  final double? weight;
  final DateTime? dateOfBirth;
  final String? sex;
  final double? height;
  final String? avatar;

  UserParams({
    required this.email,
    this.name,
    this.surname,
    this.password,
    this.weight,
    this.dateOfBirth,
    this.sex,
    this.height,
    this.avatar,
  });
}
