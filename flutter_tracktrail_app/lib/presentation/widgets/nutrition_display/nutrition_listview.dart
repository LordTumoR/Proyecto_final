import 'dart:io';
import 'package:flutter_tracktrail_app/presentation/widgets/food/food_menu.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/nutrition_display/nutrition_update.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/nutrition/nutrition_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/nutrition/nutrition_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/nutrition/nutrition_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tracktrail_app/data/models/user_database_model.dart';

class NutritionDisplayTab extends StatefulWidget {
  @override
  _NutritionDisplayTabState createState() => _NutritionDisplayTabState();
}

class _NutritionDisplayTabState extends State<NutritionDisplayTab> {
  File? _selectedImage;
  late UserDatabaseModel _user;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<NutritionBloc>(context).add(
      FetchNutritionRecords(name: '', description: '', date: null),
    );
  }

  Future<void> _pickImage(int nutritionRecordId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      context.read<NutritionBloc>().add(
            UpdateNutritionRecord(
              id: nutritionRecordId,
              imageUrl: _selectedImage!.path,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.nutrition_records,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[700],
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    style: TextStyle(color: Colors.green[800]),
                  ),
                );
              }

              final nutritionRecords = state.nutritionRecords;
              return ListView.builder(
                itemCount: nutritionRecords.length,
                itemBuilder: (context, index) {
                  final record = nutritionRecords[index];

                  return Container(
                    height: 300,
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
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nombre: ${record.name}',
                                  style: TextStyle(
                                    color: Colors.green[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Descripcion: ${record.description}',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Fecha: ${record.date}',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      tooltip: 'Subir imagen',
                                      icon: const Icon(Icons.add_a_photo),
                                      color: Colors.green[800],
                                      onPressed: () => _pickImage(record.id),
                                    ),
                                    IconButton(
                                      tooltip: 'Eliminar',
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red[400],
                                      onPressed: () {
                                        context.read<NutritionBloc>().add(
                                              DeleteNutritionRecord(
                                                  id: record.id),
                                            );
                                      },
                                    ),
                                    IconButton(
                                      tooltip: 'Editar',
                                      icon: const Icon(Icons.edit),
                                      color: Colors.green[800],
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return EditNutritionRecordDialog(
                                              id: record.id,
                                              initialName: record.name,
                                              initialDescription:
                                                  record.description,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    IconButton(
                                      tooltip: 'Ver alimentos',
                                      icon: const Icon(Icons.fastfood),
                                      color: Colors.green[600],
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return FoodTab(
                                              dietId: record.id,
                                              isUserDiet: true,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    IconButton(
                                      tooltip: 'Favorito',
                                      icon: Icon(
                                        Icons.favorite,
                                        color: record.isFavorite ?? false
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      onPressed: () {
                                        context.read<NutritionBloc>().add(
                                              UpdateNutritionRecord(
                                                id: record.id,
                                                isFavorite:
                                                    !(record.isFavorite ??
                                                        false),
                                              ),
                                            );
                                      },
                                    ),
                                  ],
                                ),
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
                style: TextStyle(color: Colors.green[800]),
              ),
            );
          },
        ),
      ),
    );
  }
}
