import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class FoodRemoteDataSource {
  Future<List<Map<String, dynamic>>> getRandomFoods();
  Future<Map<String, dynamic>> getProductByBarcode(String barcode);
}

class FoodRemoteDataSourceImpl implements FoodRemoteDataSource {
  final http.Client client;

  FoodRemoteDataSourceImpl(this.client);

  @override
  Future<List<Map<String, dynamic>>> getRandomFoods() async {
    final url = Uri.parse(
        'https://world.openfoodfacts.org/api/v2/search?fields=product_name,brands,categories,image_url,nutriments&lc=es');

    final response = await client.get(url).timeout(const Duration(seconds: 40));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> products = data['products'];

      final List<Map<String, dynamic>> filteredProducts =
          products.where((product) {
        // Verifica que el producto tenga al menos un nombre válido
        final hasValidName =
            (product['product_name_es']?.isNotEmpty ?? false) ||
                (product['product_name_en']?.isNotEmpty ?? false) ||
                (product['product_name']?.isNotEmpty ?? false);
        return hasValidName;
      }).map((product) {
        return {
          'name': product['product_name_es'] ??
              product['product_name_en'] ??
              product['product_name'] ??
              'Desconocido',
          'brand': product['brands'] ?? 'Desconocido',
          'category': product['categories'] ?? 'Desconocido',
          'imageUrl': product['image_url'] ?? '',
          'nutritionInfo': product['nutriments'] ?? {},
        };
      }).toList();
      print(products);
      return filteredProducts;
    } else {
      throw Exception('Error al cargar los alimentos: ${response.statusCode}');
    }
  }

  @override
  Future<Map<String, dynamic>> getProductByBarcode(String barcode) async {
    final url = Uri.parse(
        'https://world.openfoodfacts.org/api/v0/product/$barcode.json');

    final response = await client.get(url).timeout(const Duration(seconds: 40));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['status'] == 1) {
        final Map<String, dynamic> product = data['product'];

        return {
          'name': product['product_name_es'] ??
              product['product_name_en'] ??
              product['product_name'] ??
              'Desconocido',
          'brand': product['brands'] ?? 'Desconocido',
          'category': product['categories'] ?? 'Desconocido',
          'imageUrl': product['image_url'] ?? '',
          'nutritionInfo': (product['nutriments'] != null &&
                  product['nutriments']['energy-kcal'] != null)
              ? product['nutriments']['energy-kcal'].toDouble()
              : 0.0,
        };
      } else {
        throw Exception('Producto no encontrado');
      }
    } else {
      throw Exception('Error al cargar el producto: ${response.statusCode}');
    }
  }
}
