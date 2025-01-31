import 'package:flutter_tracktrail_app/data/models/user_database_model.dart';

abstract class NutritionEvent {}

class FetchNutritionRecords extends NutritionEvent {
  final String name;
  final String description;
  final DateTime? date;

  FetchNutritionRecords({
    required this.name,
    required this.description,
    this.date,
  });
}

class CreateNutritionRecord extends NutritionEvent {
  final String name;
  final String description;
  final DateTime date;
  final int userId;

  CreateNutritionRecord({
    required this.name,
    required this.description,
    required this.date,
    required this.userId,
  });
}

class UpdateNutritionRecord extends NutritionEvent {
  final int? id;
  final String? name;
  final String? description;
  final DateTime? date;
  final int? userId;

  UpdateNutritionRecord({
    this.id,
    this.name,
    this.description,
    this.date,
    this.userId,
  });
}

class DeleteNutritionRecord extends NutritionEvent {
  final int id;

  DeleteNutritionRecord({required this.id});
}
