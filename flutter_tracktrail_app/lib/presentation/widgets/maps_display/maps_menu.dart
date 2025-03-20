import 'package:flutter/material.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/maps_display/Consult_routes_map.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/maps_display/maps_follow_route.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/maps_display/maps_generate.dart';
import 'package:flutter_tracktrail_app/presentation/widgets/maps_display/maps_generate_manual.dart';

class RutasMapasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rutas y Mapas',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildOptionTile(
                    context,
                    title: 'Seguir Ruta',
                    icon: Icons.directions_walk,
                    description: 'Empieza a Registrar Tu ruta.',
                    color: Colors.green.shade700,
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LiveTrackingScreen()),
                      );
                    },
                  ),
                  _buildOptionTile(
                    context,
                    title: 'Crear Ruta Automáticamente',
                    icon: Icons.auto_mode,
                    description: 'Genera una ruta según distancia y ubicación.',
                    color: Colors.orange.shade700,
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapsScreen()),
                      );
                    },
                  ),
                  _buildOptionTile(
                    context,
                    title: 'Crear Ruta Manualmente',
                    icon: Icons.edit_location_alt,
                    description: 'Dibuja tu propia ruta en el mapa.',
                    color: Colors.purple.shade700,
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DrawRouteScreen()),
                      );
                    },
                  ),
                  _buildOptionTile(
                    context,
                    title: 'Consultar Mapa',
                    icon: Icons.map,
                    description: 'Visualiza mapas y explora rutas disponibles.',
                    color: Colors.blue.shade700,
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConsultarMapaScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: color, width: 2),
      ),
      elevation: 8.0,
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, size: 36.0, color: color),
        title: Text(
          title,
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87),
        ),
        subtitle: Text(description,
            style: TextStyle(color: Colors.black54, fontSize: 16.0)),
        trailing: Icon(Icons.arrow_forward_ios, color: color),
        onTap: onTap,
      ),
    );
  }
}
