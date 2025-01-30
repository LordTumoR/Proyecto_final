import 'package:equatable/equatable.dart';
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
