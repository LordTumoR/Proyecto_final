import 'package:flutter_tracktrail_app/domain/entities/nutrition_entity.dart';

class NutritionModel {
  final int? id;
  final String? name;
  final String? description;
  final DateTime? date;
  final int? userId;
  final String? imageUrl;
  final bool? isFavorite;

  NutritionModel({
    this.id,
    this.name,
    this.description,
    this.date,
    this.userId,
    this.imageUrl,
    this.isFavorite,
  });

  @override
  String toString() {
    return 'NutritionModel{id: $id, name: $name, description: $description, date: $date, userId: $userId}';
  }

  factory NutritionModel.fromJson(Map<String, dynamic> json) {
    return NutritionModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      userId: json['user_id'],
      imageUrl: json['imageurl'],
      isFavorite: json['isFavorite'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date?.toIso8601String(),
      'user_id': userId,
      'imageurl': imageUrl,
      'isFavorite': isFavorite,
    };
  }

  NutritionEntity toEntity() {
    return NutritionEntity(
      id: id ?? 0,
      name: name ?? '',
      description: description ?? '',
      date: date,
      userId: userId,
      imageUrl: imageUrl ?? '',
      isFavorite: isFavorite ?? true,
    );
  }
}
