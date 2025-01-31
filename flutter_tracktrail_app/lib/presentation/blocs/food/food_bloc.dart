import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/domain/usecases/create_food_database_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_foods_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_openfoodfacts_food_usecase.dart';
import 'package:flutter_tracktrail_app/domain/usecases/update_food_usecase.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodUseCase foodUseCase;
  final GetNutritionFoods foodDatabaseUseCase;
  final CreateFood createFoodUseCase;
  final UpdateFood updateFoodUseCase;

  FoodBloc(this.createFoodUseCase, this.foodUseCase, this.foodDatabaseUseCase,
      this.updateFoodUseCase)
      : super(FoodInitial()) {
    on<LoadRandomFoods>(_onLoadRandomFoods);
    on<LoadDatabaseFoods>(_onLoadDatabaseFoods);
    on<CreateFoodEvent>(_onCreateFood);
    on<UpdateFoodEvent>(_onUpdateFood);
  }
  Future<void> _onLoadRandomFoods(
      LoadRandomFoods event, Emitter<FoodState> emit) async {
    emit(FoodLoading());

    final result = await foodUseCase();

    result.fold(
      (failure) => emit(FoodError(failure)),
      (foods) => emit(FoodLoaded(foods)),
    );
  }

  Future<void> _onLoadDatabaseFoods(
      LoadDatabaseFoods event, Emitter<FoodState> emit) async {
    emit(FoodLoading());

    final result = await foodDatabaseUseCase(event.dietId);

    result.fold(
      (failure) => emit(FoodError(failure)),
      (foods) {
        final filteredFoods = foods.where((food) {
          if (event.name != null &&
              !food.name.toLowerCase().contains(event.name!.toLowerCase())) {
            return false;
          }
          if (event.minCalories != null &&
              (food.calories ?? 0) < event.minCalories!) {
            return false;
          }
          if (event.maxCalories != null &&
              (food.calories ?? 0) > event.maxCalories!) {
            return false;
          }
          if (event.category != null &&
              food.category.toLowerCase() != event.category!.toLowerCase()) {
            return false;
          }
          if (event.brand != null &&
              food.brand.toLowerCase() != event.brand!.toLowerCase()) {
            return false;
          }
          return true;
        }).toList();

        emit(FoodDatabaseLoaded(filteredFoods));
      },
    );
  }

  Future<void> _onCreateFood(
      CreateFoodEvent event, Emitter<FoodState> emit) async {
    emit(FoodLoading());
    try {
      final createdFood = await createFoodUseCase(event.food, event.dietId);

      emit(FoodCreated(createdFood));

      if (event.loadRandomFoods) {
        add(LoadRandomFoods());
      } else {
        add(
          LoadDatabaseFoods(
            dietId: event.dietId,
            name: null,
            minCalories: null,
            maxCalories: null,
            category: null,
            brand: null,
          ),
        );
      }
    } catch (e) {
      emit(FoodError('Error al crear el alimento: $e'));
    }
  }

  Future<void> _onUpdateFood(
      UpdateFoodEvent event, Emitter<FoodState> emit) async {
    emit(FoodLoading());
    try {
      final updatedFood = await updateFoodUseCase(event.food);
      emit(FoodUpdated(updatedFood));
      add(
        LoadDatabaseFoods(
          dietId: event.dietId,
          name: null,
          minCalories: null,
          maxCalories: null,
          category: null,
          brand: null,
        ),
      );
    } catch (e) {
      emit(FoodError('Error al actualizar el alimento: $e'));
    }
  }
}
