import 'package:flutter/material.dart';
import 'package:flutter_tracktrail_app/domain/entities/user_database_entity.dart';

class PersonalInfoDialog extends StatelessWidget {
  final UserDatabaseEntity user;

  const PersonalInfoDialog({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Información del Usuario",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoRow("Nombre:", user.name),
            _buildInfoRow("Apellido:", user.surname),
            _buildInfoRow("Correo:", user.email),
            _buildInfoRow("Peso:", "${user.weight} kg"),
            _buildInfoRow(
                "Fecha de Nacimiento:", _formatDate(user.dateOfBirth)),
            _buildInfoRow("Sexo:", user.sex),
            _buildInfoRow("Altura:", "${user.height} cm"),
            _buildInfoRow("Avatar:", user.avatar ?? "No disponible"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cerrar"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final formattedDate = "${date.day}/${date.month}/${date.year}";
    return formattedDate;
  }
}
