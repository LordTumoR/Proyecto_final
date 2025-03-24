import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart' as xml;

class ConsultarMapaScreen extends StatefulWidget {
  @override
  _ConsultarMapaScreenState createState() => _ConsultarMapaScreenState();
}

class _ConsultarMapaScreenState extends State<ConsultarMapaScreen> {
  List<String> rutasGuardadas = [];
  String? rutaSeleccionada;
  List<LatLng> routePoints = [];

  @override
  void initState() {
    super.initState();
    _cargarRutasGuardadas();
  }

  Future<void> _cargarRutasGuardadas() async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory);
    final files =
        directory.listSync().where((file) => file.path.endsWith('.gpx'));
    setState(() {
      rutasGuardadas = files.map((file) => file.path.split('/').last).toList();
    });
  }

  Future<void> _cargarRutaSeleccionada(String ruta) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$ruta');
    if (await file.exists()) {
      final contenido = await file.readAsString();
      final document = xml.XmlDocument.parse(contenido);
      final puntos = document.findAllElements('trkpt');
      setState(() {
        routePoints = puntos.map((punto) {
          final lat = double.parse(punto.getAttribute('lat')!);
          final lon = double.parse(punto.getAttribute('lon')!);
          return LatLng(lat, lon);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Consultar Mapa")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: rutaSeleccionada,
              hint: const Text("Selecciona una ruta"),
              onChanged: (value) {
                setState(() {
                  rutaSeleccionada = value;
                });
                if (value != null) {
                  _cargarRutaSeleccionada(value);
                }
              },
              items: rutasGuardadas.map((ruta) {
                return DropdownMenuItem(
                  value: ruta,
                  child: Text(ruta),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter:
                    routePoints.isNotEmpty ? routePoints.first : const LatLng(0, 0),
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),
                
                if (routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routePoints,
                        color: Colors.blue,
                        strokeWidth: 4.0,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
