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
      FetchNutritionRecords(
        name: '',
        description: '',
        date: null,
      ),
    );
  }

  Future<void> _pickImage(int nutritionRecordId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      // Puedes usar el evento para guardar la imagen si lo necesitas
      // BlocProvider.of<NutritionBloc>(context).add(
      //   SaveNutritionRecordWithImageEvent(
      //     nutritionRecordId: nutritionRecordId,
      //     file: _selectedImage!,
      //     fileName: pickedFile.name,
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.nutrition_records),
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
              final nutritionRecords = state.nutritionRecords;

              return ListView.builder(
                itemCount: nutritionRecords.length,
                itemBuilder: (context, index) {
                  final record = nutritionRecords[index];

                  return SizedBox(
                    height: 200,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            // child: Container(
                            //   width: 100.0,
                            //   height: 150.0,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(3.0),
                            //     image: DecorationImage(
                            //       image: record.imageUrl != null &&
                            //               record.imageUrl!.isNotEmpty
                            //           ? NetworkImage(record.imageUrl!)
                            //           : const AssetImage(
                            //                   'assets/placeholder.png')
                            //               as ImageProvider,
                            //       fit: BoxFit.cover,
                            //     ),
                            //     color: Colors.grey[300],
                            //   ),
                            //   child: (_selectedImage == null &&
                            //           (record.imageUrl == null ||
                            //               record.imageUrl!.isEmpty))
                            //       ? const Icon(Icons.image, size: 40)
                            //       : null,
                            // ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nombre: ${record.name}',
                                    style: const TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Descripcion: ${record.description}',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Date: ${record.date}',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _pickImage(record.id);
                                        },
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: const Icon(Icons.add_a_photo),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          BlocProvider.of<NutritionBloc>(
                                                  context)
                                              .add(
                                            DeleteNutritionRecord(
                                                id: record.id),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit),
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
                                        icon: const Icon(Icons.fastfood),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return FoodTab(dietId: record.id);
                                            },
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
                    ),
                  );
                },
              );
            }

            return Center(
                child: Text(AppLocalizations.of(context)!.no_records_found));
          },
        ),
      ),
    );
  }
}
