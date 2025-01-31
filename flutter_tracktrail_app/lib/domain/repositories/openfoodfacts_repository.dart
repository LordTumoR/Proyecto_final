import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/entities/openfoodfacts_entity.dart';

abstract class FoodRepository {
  Future<Either<String, List<FoodEntity>>> getRandomFoods();
  Future<Either<String, FoodEntity>> getProductByBarcode(String barcode);
}
