import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/data/repositories/progress_repository_impl.dart';
import 'package:flutter_tracktrail_app/domain/repositories/progress_repository.dart';

class GetPersonalRecordsUseCase {
  final ProgressRepository repository;

  GetPersonalRecordsUseCase(this.repository);

  Future<Either<String, List<dynamic>>> call() async {
    try {
      List<dynamic> result = await repository.getPersonalRecords();
      return Right(result);
    } catch (e) {
      return Left("Error occurred: $e");
    }
  }
}
