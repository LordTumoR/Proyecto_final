import 'package:flutter_tracktrail_app/domain/entities/nutrition_entity.dart';

abstract class NutritionState {}

class NutritionInitial extends NutritionState {}

class NutritionLoading extends NutritionState {}

class NutritionLoaded extends NutritionState {
  final List<NutritionEntity> nutritionRecords;

  NutritionLoaded({required this.nutritionRecords});
}

class NutritionOperationSuccess extends NutritionState {}

class NutritionOperationFailure extends NutritionState {
  final String error;

  NutritionOperationFailure({required this.error});
}
