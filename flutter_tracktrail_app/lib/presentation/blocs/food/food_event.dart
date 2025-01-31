import 'package:equatable/equatable.dart';
import 'package:flutter_tracktrail_app/domain/entities/food_entity.dart';

abstract class FoodEvent extends Equatable {
  const FoodEvent();

  @override
  List<Object?> get props => [];
}

class LoadRandomFoods extends FoodEvent {}

class LoadDatabaseFoods extends FoodEvent {
  final int dietId;
  final String? name;
  final double? minCalories;
  final double? maxCalories;
  final String? category;
  final String? brand;

  const LoadDatabaseFoods({
    required this.dietId,
    this.name,
    this.minCalories,
    this.maxCalories,
    this.category,
    this.brand,
  });

  @override
  List<Object?> get props =>
      [dietId, name, minCalories, maxCalories, category, brand];
}

class CreateFoodEvent extends FoodEvent {
  final FoodEntityDatabase food;
  final int dietId;
  final bool loadRandomFoods;

  const CreateFoodEvent(this.food, this.dietId, {this.loadRandomFoods = false});

  @override
  List<Object?> get props => [food, dietId, loadRandomFoods];
}

class UpdateFoodEvent extends FoodEvent {
  final FoodEntityDatabase food;
  final int dietId;

  const UpdateFoodEvent(this.food, this.dietId);

  @override
  List<Object?> get props => [food, dietId];
}
