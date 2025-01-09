import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/entities/user_database_entity.dart';

abstract class GetUsersInfoRepository {
  Future<Either<String, UserDatabaseEntity>> getUsers();
}
