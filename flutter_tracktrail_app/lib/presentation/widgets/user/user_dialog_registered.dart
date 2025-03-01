import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoDialog extends StatefulWidget {
  const UserInfoDialog({super.key});

  @override
  _UserInfoDialogState createState() => _UserInfoDialogState();
}

class _UserInfoDialogState extends State<UserInfoDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

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
              "Bienvenido a TrackTrail, para desbloquear todas las funciones completa la configuración inicial",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(height: 20),
            _buildTextField(_nameController, "Nombre", false),
            _buildTextField(_surnameController, "Apellido", false),
            _buildTextField(_weightController, "Peso", true),
            _buildTextField(_dobController, "Fecha de Nacimiento", false),
            _buildTextField(_sexController, "Sexo", false),
            _buildTextField(_heightController, "Altura", true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (!mounted) return;
                final prefs = await SharedPreferences.getInstance();
                final email = prefs.getString('email') ?? '';

                if (email.isEmpty) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text("No se encontró el correo electrónico")),
                    );
                  }
                  return;
                }

                final name = _nameController.text;
                final surname = _surnameController.text;
                final weightText = _weightController.text;
                final dobText = _dobController.text;
                final sex = _sexController.text;
                final heightText = _heightController.text;

                if (name.isEmpty ||
                    surname.isEmpty ||
                    sex.isEmpty ||
                    weightText.isEmpty ||
                    heightText.isEmpty ||
                    dobText.isEmpty) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Por favor complete todos los campos")),
                    );
                  }
                  return;
                }

                double? weight = double.tryParse(weightText);
                if (weight == null || weight <= 0) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Por favor ingrese un peso válido")),
                    );
                  }
                  return;
                }

                double? height = double.tryParse(heightText);
                if (height == null || height <= 0) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Por favor ingrese una altura válida")),
                    );
                  }
                  return;
                }

                DateTime? dob = DateTime.tryParse(dobText);

                final updateEvent = UpdateUserDataEvent(
                  email: email,
                  name: name,
                  surname: surname,
                  password: "userPassword",
                  weight: weight,
                  dateOfBirth: dob,
                  sex: sex,
                  height: height,
                );

                if (mounted) {
                  BlocProvider.of<LoginBloc>(context).add(updateEvent);
                }
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, bool isNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      ),
    );
  }
}
