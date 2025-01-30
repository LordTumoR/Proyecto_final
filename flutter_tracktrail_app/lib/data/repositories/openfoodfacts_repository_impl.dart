import 'package:dartz/dartz.dart';
import 'package:flutter_tracktrail_app/data/datasources/openfoodfacts_datasource.dart';
import 'package:flutter_tracktrail_app/domain/entities/openfoodfacts_entity.dart';
import 'package:flutter_tracktrail_app/domain/repositories/openfoodfacts_repository.dart';

class FoodRepositoryImpl implements FoodRepository {
  final FoodRemoteDataSource dataSource;

  FoodRepositoryImpl(this.dataSource);

  @override
  Future<Either<String, List<FoodEntity>>> getRandomFoods() async {
    try {
      final foods = await dataSource.getRandomFoods();
      print('Foods received: $foods');
      final foodEntities = foods.map((food) {
        print('Nutriments: ${food['nutriments']}');
        print('Energy-Kcal: ${food['nutriments']?['energy-kcal']}');
        return FoodEntity(
            name: food['name'] ?? 'Desconocido',
            brand: food['brand'] ?? 'Desconocido',
            category: food['category'] ?? 'Sin categoría',
            imageUrl: food['imageUrl'] ?? '',
            //ingredients: food['ingredients'] ?? 'No especificados',
            nutritionInfo: food['nutriments'] != null &&
                    food['nutriments']['energy-kcal'] != null
                ? food['nutriments']['energy-kcal']
                : 0.0);
      }).toList();

      return Right(foodEntities);
    } catch (e) {
      return Left("Error al obtener los alimentos: ${e.toString()}");
    }
  }
}
