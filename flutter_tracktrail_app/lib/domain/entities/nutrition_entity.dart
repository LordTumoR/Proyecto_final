import 'package:flutter_tracktrail_app/data/models/user_database_model.dart';

class NutritionEntity {
  final int id;
  final String name;
  final String description;
  final DateTime? date;
  final int? userId;

  NutritionEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.userId,
  });

  @override
  String toString() {
    return 'NutritionEntity{id: $id, name: $name, description: $description, date: $date, userId: $userId}';
  }
}
