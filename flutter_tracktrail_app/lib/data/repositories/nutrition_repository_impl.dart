import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/data/datasources/nutrition_datasource.dart';
import 'package:flutter_tracktrail_app/domain/entities/nutrition_entity.dart';
import 'package:flutter_tracktrail_app/domain/repositories/nutrition_repository.dart';

class NutritionRepositoryImpl implements NutritionRepository {
  final NutritionRemoteDataSource remoteDataSource;

  NutritionRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, List<NutritionEntity>>> getNutritionRecords() async {
    try {
      final nutritionModels = await remoteDataSource.getNutritionRecords();
      final nutritionEntities =
          nutritionModels.map((model) => model.toEntity()).toList();
      return Right(nutritionEntities);
    } catch (e) {
      return Left('Error al obtener los registros de nutrición: $e');
    }
  }

  @override
  Future<Either<String, void>> deleteNutritionRecord(int id) async {
    try {
      await remoteDataSource.deleteNutritionRecord(id);
      return const Right(null);
    } catch (e) {
      return Left('Error al eliminar el registro de nutrición: $e');
    }
  }

  @override
  Future<Either<String, NutritionEntity>> createNutritionRecord(
    String name,
    String description,
    DateTime date,
    int userId,
    String imageUrl,
  ) async {
    try {
      final nutritionModel = await remoteDataSource.createNutritionRecord(
        name,
        description,
        date,
        userId,
        imageUrl,
      );
      return Right(nutritionModel.toEntity());
    } catch (e) {
      return Left('Error al crear el registro de nutrición: $e');
    }
  }

  @override
  Future<Either<String, NutritionEntity>> updateNutritionRecord(
    int? id,
    String? name,
    String? description,
    DateTime? date,
    int? userId,
    String? imageUrl,
    bool? isFavorite,
  ) async {
    try {
      final nutritionModel = await remoteDataSource.updateNutritionRecord(
        id,
        name,
        description,
        date,
        userId,
        imageUrl,
        isFavorite,
      );
      return Right(nutritionModel.toEntity());
    } catch (e) {
      return Left('Error al actualizar el registro de nutrición: $e');
    }
  }
}
