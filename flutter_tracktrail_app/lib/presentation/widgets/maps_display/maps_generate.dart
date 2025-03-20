import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'dart:math';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

const String apiKey =
    "5b3ce3597851110001cf62482d35bce1377b4e9098228e711f74a971";
const String orsUrl =
    "https://api.openrouteservice.org/v2/directions/foot-walking";

class MapsScreen extends StatefulWidget {
  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  List<LatLng> routePoints = [];
  LatLng? currentPosition;
  final TextEditingController _distanceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  LatLng calcularPuntoDistancia(LatLng origen, double distancia) {
    double lat1 = origen.latitude * pi / 180;
    double lon1 = origen.longitude * pi / 180;
    double d = distancia;
    double R = 6371000;

    double lat2 = lat1 + (d / R);
    double lon2 = lon1 + (d / (R * cos(lat1)));

    lat2 = lat2 * 180 / pi;
    lon2 = lon2 * 180 / pi;

    return LatLng(lat2, lon2);
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    const double R = 6371000;
    double lat1 = point1.latitude * pi / 180;
    double lon1 = point1.longitude * pi / 180;
    double lat2 = point2.latitude * pi / 180;
    double lon2 = point2.longitude * pi / 180;

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  Future<void> _generateRoute() async {
    if (currentPosition == null) {
      print("No se ha obtenido la posición actual.");
      return;
    }

    double? distanceKm = double.tryParse(_distanceController.text);
    if (distanceKm == null || distanceKm <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, ingresa una distancia válida.")),
      );
      return;
    }

    double startLongitude = currentPosition!.longitude;
    double startLatitude = currentPosition!.latitude;

    LatLng destino =
        calcularPuntoDistancia(currentPosition!, distanceKm * 1000);

    try {
      Response response = await Dio().post(
        orsUrl,
        options: Options(headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json"
        }),
        data: {
          "coordinates": [
            [startLongitude, startLatitude],
            [destino.longitude, destino.latitude]
          ],
          "geometry": "true",
          "instructions": "false",
          "preference": "shortest",
        },
      );

      if (response.data != null &&
          response.data['routes'] != null &&
          response.data['routes'].isNotEmpty) {
        var route = response.data['routes'][0];

        if (route['summary'] != null && route['summary']['distance'] != null) {
          double routeDistance = route['summary']['distance'] / 1000;
          print("Distancia total de la ruta: $routeDistance km");

          if (routeDistance > distanceKm) {
            String encodedPolyline = route['geometry'];
            PolylinePoints polylinePoints = PolylinePoints();
            List<PointLatLng> decodedPolyline =
                polylinePoints.decodePolyline(encodedPolyline);

            double totalDistance = 0.0;
            List<PointLatLng> truncatedPolyline = [];

            for (int i = 0; i < decodedPolyline.length - 1; i++) {
              double distance = _calculateDistance(
                LatLng(
                    decodedPolyline[i].latitude, decodedPolyline[i].longitude),
                LatLng(decodedPolyline[i + 1].latitude,
                    decodedPolyline[i + 1].longitude),
              );

              totalDistance += distance;

              truncatedPolyline.add(decodedPolyline[i]);

              if (totalDistance >= distanceKm * 1000) {
                break;
              }
            }

            setState(() {
              routePoints = truncatedPolyline
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();
            });

            print("Ruta recortada a ${distanceKm} km.");
          } else {
            String encodedPolyline = route['geometry'];
            PolylinePoints polylinePoints = PolylinePoints();
            List<PointLatLng> decodedPolyline =
                polylinePoints.decodePolyline(encodedPolyline);

            setState(() {
              routePoints = decodedPolyline
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();
            });
          }
        } else {
          print("No se encontró la distancia en la sección 'summary'.");
        }
      }
    } catch (e) {
      print("Error al generar la ruta: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Generar Ruta")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _distanceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Distancia en km",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _generateRoute,
                  child: Text("Generar"),
                ),
              ],
            ),
          ),
          Expanded(
            child: currentPosition == null
                ? Center(child: CircularProgressIndicator())
                : FlutterMap(
                    options: MapOptions(
                      initialCenter: currentPosition!,
                      initialZoom: 13.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
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
