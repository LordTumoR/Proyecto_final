import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateInfoDialog extends StatefulWidget {
  final VoidCallback onInfoUpdated;

  const UpdateInfoDialog({Key? key, required this.onInfoUpdated})
      : super(key: key);

  @override
  _UpdateInfoDialogState createState() => _UpdateInfoDialogState();
}

class _UpdateInfoDialogState extends State<UpdateInfoDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _avatarController = TextEditingController();
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
            Text(
              AppLocalizations.of(context)!.update_user_info,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(height: 20),
            _buildTextField(
                _nameController, AppLocalizations.of(context)!.name),
            _buildTextField(
                _surnameController, AppLocalizations.of(context)!.surname),
            _buildTextField(
                _weightController, AppLocalizations.of(context)!.weight),
            _buildTextField(
                _avatarController, AppLocalizations.of(context)!.avatar),
            _buildTextField(_sexController, AppLocalizations.of(context)!.sex),
            _buildTextField(
                _heightController, AppLocalizations.of(context)!.height),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (!mounted) return;
                final prefs = await SharedPreferences.getInstance();
                final email = prefs.getString('email') ?? '';

                if (email.isEmpty) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              AppLocalizations.of(context)!.no_email_found)),
                    );
                  }
                  return;
                }

                final name = _nameController.text;
                final surname = _surnameController.text;
                final weight = double.tryParse(_weightController.text) ?? 0.0;
                final avatar = _avatarController.text;
                final sex = _sexController.text;
                final height = double.tryParse(_heightController.text) ?? 0.0;

                final updateEvent = UpdateUserDataEvent(
                  email: email,
                  name: name,
                  surname: surname,
                  password: "userPassword",
                  weight: weight,
                  avatar: avatar,
                  sex: sex,
                  height: height,
                );

                if (mounted) {
                  BlocProvider.of<LoginBloc>(context).add(updateEvent);
                }
                widget.onInfoUpdated();
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
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
      ),
    );
  }
}
