import 'package:flutter_tracktrail_app/domain/entities/food_entity.dart';

class FoodModelDatabase {
  final int? id;
  final String name;
  final String? brand;
  final String? category;
  final double? calories;
  final double? carbohydrates;
  final double? protein;
  final double? fat;
  final double? fiber;
  final double? sugar;
  final double? sodium;
  final double? cholesterol;
  final String? mealtype;
  final DateTime? date;

  FoodModelDatabase({
    this.id,
    required this.name,
    this.brand,
    this.category,
    this.calories,
    this.carbohydrates,
    this.protein,
    this.fat,
    this.fiber,
    this.sugar,
    this.sodium,
    this.cholesterol,
    this.mealtype,
    this.date,
  });

  factory FoodModelDatabase.fromJson(Map<String, dynamic> json) {
    return FoodModelDatabase(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      category: json['category'],
      calories: (json['calories'] as num?)?.toDouble(),
      carbohydrates: (json['carbohydrates'] as num?)?.toDouble(),
      protein: (json['protein'] as num?)?.toDouble(),
      fat: (json['fat'] as num?)?.toDouble(),
      fiber: (json['fiber'] as num?)?.toDouble(),
      sugar: (json['sugar'] as num?)?.toDouble(),
      sodium: (json['sodium'] as num?)?.toDouble(),
      cholesterol: (json['cholesterol'] as num?)?.toDouble(),
      mealtype: json['mealtype'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'calories': calories,
      'carbohydrates': carbohydrates,
      'protein': protein,
      'fat': fat,
      'fiber': fiber,
      'sugar': sugar,
      'sodium': sodium,
      'cholesterol': cholesterol,
      'mealtype': mealtype,
      'date': date?.toIso8601String(),
    };
  }

  FoodEntityDatabase toEntity() {
    return FoodEntityDatabase(
      id: id ?? 0,
      name: name,
      brand: brand ?? '',
      category: category ?? '',
      calories: calories ?? 0.0,
      carbohydrates: carbohydrates ?? 0.0,
      protein: protein ?? 0.0,
      fat: fat ?? 0.0,
      fiber: fiber ?? 0.0,
      sugar: sugar ?? 0.0,
      sodium: sodium ?? 0.0,
      cholesterol: cholesterol ?? 0.0,
      mealtype: mealtype ?? '',
      date: date ?? DateTime.now(),
    );
  }
}
