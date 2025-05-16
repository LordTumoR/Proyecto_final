import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/nutrition/nutrition_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/nutrition/nutrition_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/nutrition/nutrition_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/food/food_menu.dart';

class NutritionDisplayTabSearch extends StatefulWidget {
  @override
  _NutritionDisplayTabSearchState createState() => _NutritionDisplayTabSearchState();
}

class _NutritionDisplayTabSearchState extends State<NutritionDisplayTabSearch> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<NutritionBloc>(context).add(
      FetchNutritionRecords(name: '', description: '', date: null),
    );
  }

  void _createNutritionRecord(String name, String description, DateTime date) {
    BlocProvider.of<NutritionBloc>(context).add(
      CreateNutritionRecord(
        name: name,
        description: description,
        date: date,
        userId: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // fondo verde claro
      appBar: AppBar(
        elevation: 2,
        backgroundColor: const Color(0xFF4CAF50),
        title: Text(
          AppLocalizations.of(context)!.nutrition_records,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocBuilder<NutritionBloc, NutritionState>(
          builder: (context, state) {
            if (state is NutritionLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NutritionOperationFailure) {
              return Center(
                child: Text(
                  'Error: ${state.error}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (state is NutritionLoaded) {
              if (state.nutritionRecords.isEmpty) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.no_records_found,
                    style: TextStyle(color: Colors.green[900]),
                  ),
                );
              }

              final nutritionRecords = state.nutritionRecords;

              return ListView.builder(
                itemCount: nutritionRecords.length,
                itemBuilder: (context, index) {
                  final record = nutritionRecords[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              width: 100,
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                border: Border.all(
                                  color: Colors.green.shade300,
                                  width: 2,
                                ),
                              ),
                              child: record.imageUrl != null &&
                                      record.imageUrl!.isNotEmpty
                                  ? Image.network(
                                      record.imageUrl!,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.image, size: 40),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 16.0, top: 16.0, bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  record.name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[900],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  record.description,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '📅 ${record.date?.toLocal().toString().split(' ')[0] ?? '-'}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.fastfood),
                                      color: Colors.green[700],
                                      tooltip: 'Ver alimentos',
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => FoodTab(
                                            dietId: record.id,
                                            isUserDiet: false,
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.copy),
                                      color: Colors.green[600],
                                      tooltip: 'Copiar registro',
                                      onPressed: () {
                                        _createNutritionRecord(
                                          record.name,
                                          record.description,
                                          record.date ?? DateTime.now(),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            return Center(
              child: Text(
                AppLocalizations.of(context)!.no_records_found,
                style: TextStyle(color: Colors.green[900]),
              ),
            );
          },
        ),
      ),
    );
  }
}
