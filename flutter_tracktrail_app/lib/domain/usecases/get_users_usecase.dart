import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/entities/user_database_entity.dart';
import 'package:flutter_tracktrail_app/domain/repositories/get_users_info_repository.dart';

class GetUsersUseCase {
  final GetUsersInfoRepository userRepository;

  GetUsersUseCase(this.userRepository);

  Future<Either<String, UserDatabaseEntity>> call() async {
    try {
      final result = await userRepository.getUsers();
      return result.fold(
        (error) => Left(error),
        (user) => Right(user),
      );
    } catch (e) {
      return Left('Error al obtener el usuario: ${e.toString()}');
    }
  }
}
