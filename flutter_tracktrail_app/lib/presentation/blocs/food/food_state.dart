import 'package:equatable/equatable.dart';
import 'package:flutter_tracktrail_app/domain/entities/food_entity.dart';
import 'package:flutter_tracktrail_app/domain/entities/openfoodfacts_entity.dart';

abstract class FoodState extends Equatable {
  const FoodState();

  @override
  List<Object?> get props => [];
}

class FoodInitial extends FoodState {}

class FoodLoading extends FoodState {}

class FoodLoaded extends FoodState {
  final List<FoodEntity> foodList;

  const FoodLoaded(this.foodList);

  @override
  List<Object?> get props => [foodList];
}

class FoodError extends FoodState {
  final String errorMessage;

  const FoodError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class FoodDatabaseLoaded extends FoodState {
  final List<FoodEntityDatabase> foodList;

  const FoodDatabaseLoaded(this.foodList);

  @override
  List<Object?> get props => [foodList];
}

class FoodCreated extends FoodState {
  final FoodEntityDatabase food;

  const FoodCreated(this.food);

  @override
  List<Object?> get props => [food];
}

class FoodUpdated extends FoodState {
  final FoodEntityDatabase food;

  const FoodUpdated(this.food);

  @override
  List<Object?> get props => [food];
}
