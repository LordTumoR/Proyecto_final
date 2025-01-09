import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/data/datasources/users_datasource.dart';
import 'package:flutter_tracktrail_app/domain/entities/user_database_entity.dart';
import 'package:flutter_tracktrail_app/domain/repositories/get_users_info_repository.dart';

class GetUsersInfoRepositoryImpl implements GetUsersInfoRepository {
  final UserRemoteDataSource userRemoteDataSource;

  GetUsersInfoRepositoryImpl(this.userRemoteDataSource);

  @override
  Future<Either<String, UserDatabaseEntity>> getUsers() async {
    try {
      final userModel = await userRemoteDataSource.getUsers();
      final userEntity = userModel.toEntity();

      return Right(userEntity);
    } catch (e) {
      return Left('Error al obtener el usuario: ${e.toString()}');
    }
  }
}
