import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_state.dart';

class SearchFoodsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodBloc, FoodState>(
      builder: (context, state) {
        if (state is FoodLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FoodError) {
          return const Center(
            child: Text(
              'Error al cargar los alimentos',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        } else if (state is FoodLoaded) {
          final foodList = state.foodList;

          return ListView.builder(
            itemCount: foodList.length,
            itemBuilder: (context, index) {
              final foodItem = foodList[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  title: Row(
                    children: [
                      if (foodItem.imageUrl != null &&
                          foodItem.imageUrl!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                12.0), // Bordes redondeados
                            child: Image.network(
                              foodItem.imageUrl!,
                              width: 120, // Tamaño de la imagen más grande
                              height: 200, // Tamaño de la imagen más grande
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              foodItem.name ?? 'Nombre no disponible',
                              style: const TextStyle(
                                color: Colors.brown,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              'Marca: ${foodItem.brand ?? 'Desconocido'}',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Categoría: ${foodItem.category ?? 'Desconocida'}',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Calorías: ${foodItem.nutritionInfo?.toStringAsFixed(2) ?? 'N/A'} kcal',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        return Center(child: Text('No hay alimentos disponibles'));
      },
    );
  }
}
