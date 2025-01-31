import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/domain/entities/openfoodfacts_entity.dart';

import 'package:flutter_tracktrail_app/domain/repositories/openfoodfacts_repository.dart';

class GetProductByBarcodeUseCase {
  final FoodRepository repository;

  GetProductByBarcodeUseCase(this.repository);

  Future<Either<String, FoodEntity>> call(String barcode) async {
    try {
      return await repository.getProductByBarcode(barcode);
    } catch (e) {
      return Left('Error al obtener el producto por código de barras: $e');
    }
  }
}
