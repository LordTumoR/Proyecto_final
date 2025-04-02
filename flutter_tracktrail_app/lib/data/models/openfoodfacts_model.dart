import 'package:flutter_tracktrail_app/data/models/user_database_model.dart';
import 'package:flutter_tracktrail_app/domain/entities/openfoodfacts_entity.dart';

class FoodModel {
  final String? name;
  final String? brand;
  final String? category;
  final String? imageUrl;
  //final String? ingredients;
  final double? nutritionInfo;

  FoodModel({
    this.name,
    this.brand,
    this.category,
    this.imageUrl,
    //this.ingredients,
    this.nutritionInfo,
  });

  @override
  String toString() {
    return 'Food{name: $name, brand: $brand, category: $category, imageUrl: $imageUrl, nutritionInfo: $nutritionInfo}';
  }

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      name: json['product_name_es'] ?? json['product_name'] ?? 'Desconocido',
      brand: json['brands'] ?? 'Desconocido',
      category: json['categories'] ?? 'Desconocido',
      imageUrl: json['image_url'] ?? '',
      // Si necesitas los ingredientes en español, agrégalo:
      // ingredients: json['ingredients_text_es'] ?? 'No disponible',
      nutritionInfo: json['nutriments']?['energy-kcal'] != null
          ? (json['nutriments']['energy-kcal'] is num
              ? json['nutriments']['energy-kcal'].toDouble()
              : double.tryParse(json['nutriments']['energy-kcal'].toString()) ??
                  0.0)
          : 0.0, // Si no existe, asigna 0.0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': name,
      'brands': brand,
      'categories': category,
      'image_url': imageUrl,
      //'ingredients_text': ingredients,
      'nutriments': nutritionInfo,
    };
  }

  FoodEntity toEntity() {
    return FoodEntity(
      name: name ?? 'Desconocido',
      brand: brand ?? 'Desconocido',
      category: category ?? 'Desconocido',
      imageUrl: imageUrl ?? '',
      // ingredients: ingredients ?? 'No disponible',
      nutritionInfo: nutritionInfo ?? 0.0,
    );
  }
}
