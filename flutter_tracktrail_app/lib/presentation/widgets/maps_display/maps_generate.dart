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
    _getCurrentLocation().then((_) => _startLocationUpdates());

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
List<LatLng> generarPuntosAleatorios(LatLng centro, double radio, int cantidad) {
  final List<LatLng> puntos = [];

  for (int i = 0; i < cantidad; i++) {
    double angulo = (2 * pi * i) / cantidad;

    double deltaLat = (radio / 6371000) * cos(angulo);
    double deltaLon = (radio / 6371000) * sin(angulo) / cos(centro.latitude * pi / 180);

    double lat = centro.latitude + deltaLat * (180 / pi);
    double lon = centro.longitude + deltaLon * (180 / pi);

    puntos.add(LatLng(lat, lon));
  }

  return puntos;
}

List<LatLng> generarPuntosCirculares(LatLng centro, double distanciaMetros, int cantidadPuntos) {
  List<LatLng> puntos = [];

  for (int i = 0; i < cantidadPuntos; i++) {
    double angulo = 2 * pi * i / cantidadPuntos;
    double dx = distanciaMetros * cos(angulo);
    double dy = distanciaMetros * sin(angulo);

    double deltaLat = (dy / 111320); // 1 grado latitud ~ 111.32 km
    double deltaLng = (dx / (111320 * cos(centro.latitude * pi / 180)));

    puntos.add(LatLng(centro.latitude + deltaLat, centro.longitude + deltaLng));
  }

  return puntos;
}
void _startLocationUpdates() {
  Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 5, // actualiza cada 5 metros
    ),
  ).listen((Position position) {
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
  });
}

List<List<double>> armarCoordenadasORS(LatLng inicio, List<LatLng> intermedios) {
  final coords = [
    [inicio.longitude, inicio.latitude], // Punto de inicio
    ...intermedios.map((p) => [p.longitude, p.latitude]), // Puntos alrededor
    [inicio.longitude, inicio.latitude], // Punto final igual que el inicial
  ];
  return coords;
}Future<void> _generarRutaCircular(double distanciaKm) async {
  if (currentPosition == null) return;

  final puntos = generarPuntosCirculares(currentPosition!, distanciaKm * 500, 12); // 6 puntos alrededor
  final coordenadas = armarCoordenadasORS(currentPosition!, puntos);

  try {
    Response response = await Dio().post(
      orsUrl,
      options: Options(headers: {
        "Authorization": apiKey,
        "Content-Type": "application/json"
      }),
      data: {
        "coordinates": coordenadas,
        "geometry": true,
        "instructions": false,
        "preference": "shortest",
        "radiuses": List.filled(coordenadas.length, 10000),

      },
    );

    if (response.data != null && response.data['routes'] != null) {
      final geometry = response.data['routes'][0]['geometry'];
      final polylinePoints = PolylinePoints().decodePolyline(geometry);
      final latLngs = polylinePoints
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();

      setState(() {
        routePoints = latLngs;
      });
    }
  } catch (e) {
    print("Error generando ruta circular: $e");
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Row(
    children: [
      Icon(Icons.terrain),  
      SizedBox(width: 10), 
      Text("Generar Ruta"),
    ],
  ),
),
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
                    decoration: const InputDecoration(
                      labelText: "Distancia en km",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
  onPressed: () {
    final km = double.tryParse(_distanceController.text);
    if (km != null && km > 0) {
      _generarRutaCircular(km);
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,      
    foregroundColor: Colors.white,    
    padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 12), 
    shape: RoundedRectangleBorder(  
      borderRadius: BorderRadius.circular(30),  
    ),
    elevation: 5,              
    // ignore: deprecated_member_use
    shadowColor: Colors.black.withOpacity(0.3), 
    side: const BorderSide(
      color: Colors.blueAccent,  
      width: 2,                 
    ),
  ),
  child: const Text(
    "Generar",
    style: TextStyle(
      fontSize: 18,           
      fontWeight: FontWeight.bold, 
    ),
  ),
)


              ],
            ),
          ),
          Expanded(
            child: currentPosition == null
                ? const Center(child: CircularProgressIndicator())
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
        ],
      ),
    );
  }
}
