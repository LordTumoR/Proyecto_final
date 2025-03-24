import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:gpx/gpx.dart';

class DrawRouteScreen extends StatefulWidget {
  @override
  _DrawRouteScreenState createState() => _DrawRouteScreenState();
}

class _DrawRouteScreenState extends State<DrawRouteScreen> {
  List<LatLng> routePoints = [];
  LatLng? currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
      routePoints.add(currentPosition!); // Punto inicial
    });
  }

  void _addPoint(LatLng point) {
    setState(() {
      routePoints.add(point);
    });
  }

  Future<void> _saveRouteAsGPX() async {
    if (routePoints.isEmpty) return;
    Gpx gpx = Gpx();
    gpx.trks = [
      Trk(trksegs: [
        Trkseg(
            trkpts: routePoints
                .map((point) => Wpt(lat: point.latitude, lon: point.longitude))
                .toList())
      ])
    ];

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/ruta.gpx');
    await file.writeAsString(GpxWriter().asString(gpx, pretty: true));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Ruta guardada en ${file.path}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dibujar Ruta")),
      body: Column(
        children: [
          Expanded(
            child: currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : FlutterMap(
                    options: MapOptions(
                      initialCenter: currentPosition!,
                      initialZoom: 15.0,
                      onTap: (tapPosition, point) => _addPoint(point),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      ),
                      MarkerLayer(
                      markers: [
                        if (currentPosition != null)
                          Marker(
                            width: 40.0,
                            height: 40.0,
                            point: currentPosition!,
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                      ],
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: _saveRouteAsGPX,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.save, color: Colors.white),
                  SizedBox(width: 10),
                  Text("Guardar Ruta", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
