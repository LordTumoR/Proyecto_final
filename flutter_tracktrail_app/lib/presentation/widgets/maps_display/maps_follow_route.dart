import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';

class LiveTrackingScreen extends StatefulWidget {
  @override
  _LiveTrackingScreenState createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  List<LatLng> routePoints = [];
  LatLng? currentPosition;
  Timer? _timer;
  bool isTracking = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
      routePoints.add(currentPosition!);
    });
  }

  void _startTracking() {
    if (isTracking) return;
    setState(() => isTracking = true);
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
        routePoints.add(currentPosition!);
      });
    });
  }

  void _stopTracking() {
    _timer?.cancel();
    setState(() => isTracking = false);
    _saveRouteToGPX();
  }

  Future<void> _saveRouteToGPX() async {
    if (routePoints.isEmpty) return;
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = "${directory.path}/ruta.gpx";

    String gpxContent = """
      <gpx version="1.1" creator="FlutterApp">
        <trk><name>Ruta Registrada</name><trkseg>
        ${routePoints.map((point) => '<trkpt lat="${point.latitude}" lon="${point.longitude}"></trkpt>').join('\n')}
        </trkseg></trk>
      </gpx>
    """;

    File file = File(filePath);
    await file.writeAsString(gpxContent);
    print("Ruta guardada en: $filePath");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro de Ruta")),
      body: Column(
        children: [
          Expanded(
            child: currentPosition == null
                ? Center(child: CircularProgressIndicator())
                : FlutterMap(
                    options: MapOptions(
                      initialCenter: currentPosition!,
                      initialZoom: 15.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      ),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: isTracking ? null : _startTracking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text("Iniciar Ruta"),
                ),
                ElevatedButton(
                  onPressed: isTracking ? _stopTracking : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text("Detener y Guardar"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
