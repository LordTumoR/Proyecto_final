import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/domain/usecases/get_openfoodfacts_food_usecase.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodUseCase foodUseCase;

  FoodBloc(this.foodUseCase) : super(FoodInitial()) {
    on<LoadRandomFoods>(_onLoadRandomFoods);
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
}
