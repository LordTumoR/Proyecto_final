import 'package:flutter/material.dart';
import 'package:flutter_tracktrail_app/domain/entities/food_entity.dart';
import 'package:flutter_tracktrail_app/domain/entities/openfoodfacts_entity.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/Food/food_state.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScannerTab extends StatefulWidget {
  final int dietId;
  const ScannerTab({required this.dietId, Key? key}) : super(key: key);

  @override
  _ScannerTabState createState() => _ScannerTabState();
}

class _ScannerTabState extends State<ScannerTab> {
  String _scannedCode = "";

  Future<String?> _scanBarcode() async {
    String? result = await SimpleBarcodeScanner.scanBarcode(
      context,
      barcodeAppBar: const BarcodeAppBar(
        appBarTitle: 'Escanear Código',
        centerTitle: true,
        enableBackButton: true,
        backButtonIcon: Icon(Icons.arrow_back_ios),
      ),
      isShowFlashIcon: true,
      delayMillis: 1000,
      cameraFace: CameraFace.back,
    );

    return result; // Devuelve el código escaneado
  }

  Future<void> _onScanBarcode() async {
    String? barcode = await _scanBarcode();

    if (barcode != null && barcode.isNotEmpty) {
      setState(() {
        _scannedCode = barcode;
      });

      // Envía el código escaneado al Bloc
      context.read<FoodBloc>().add(GetProductByBarcodeEvent(barcode));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escáner de Código de Barras'),
        backgroundColor: const Color.fromARGB(255, 249, 223, 129),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _scannedCode.isNotEmpty
                  ? "Código escaneado: $_scannedCode"
                  : "No se ha escaneado ningún código",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: _onScanBarcode,
            child: const Text('Abrir Escáner'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<FoodBloc, FoodState>(
              builder: (context, state) {
                if (state is FoodLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FoodError) {
                  return const Center(child: Text('Error al cargar los datos'));
                } else if (state is FoodLoaded) {
                  final foodList = state.foodList;
                  return ListView.builder(
                    itemCount: foodList.length,
                    itemBuilder: (context, index) {
                      final product = foodList[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Nombre: ${product.name}'),
                              Text('Marca: ${product.brand}'),
                              Text('Categoría: ${product.category}'),
                              Text(
                                  'Información Nutricional: ${product.nutritionInfo} kcal'),
                              if (product.imageUrl!.isNotEmpty)
                                Image.network(product.imageUrl!),
                              IconButton(
                                icon: const Icon(Icons.add,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                                onPressed: () {
                                  _addFoodItem(product);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addFoodItem(FoodEntity foodItem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Añadir alimento'),
          content: Text('¿Deseas añadir ${foodItem.name} a tu lista?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final foodEntity = FoodEntityDatabase(
                  id: 0,
                  name: foodItem.name ?? '',
                  brand: foodItem.brand ?? '',
                  category: foodItem.category ?? '',
                  calories: foodItem.nutritionInfo,
                  carbohydrates: 0,
                  protein: 0,
                  fat: 0,
                  fiber: 0,
                  sugar: 0,
                  sodium: 0,
                  cholesterol: 0,
                );

                context.read<FoodBloc>().add(CreateFoodEvent(
                    foodEntity, widget.dietId,
                    loadRandomFoods: true));
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${foodItem.name} añadido correctamente'),
                  ),
                );
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }
}
