import 'package:flutter/material.dart';
import 'package:flutter_tracktrail_app/domain/entities/user_database_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            Text(
              AppLocalizations.of(context)!.user_info,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoRow(AppLocalizations.of(context)!.name, user.name),
            _buildInfoRow(AppLocalizations.of(context)!.surname, user.surname),
            _buildInfoRow(AppLocalizations.of(context)!.email, user.email),
            _buildInfoRow(
                AppLocalizations.of(context)!.weight, "${user.weight} kg"),
            _buildInfoRow(AppLocalizations.of(context)!.date_of_birth,
                _formatDate(user.dateOfBirth)),
            _buildInfoRow(AppLocalizations.of(context)!.sex, user.sex),
            _buildInfoRow(
                AppLocalizations.of(context)!.height, "${user.height} cm"),
            _buildInfoRow(AppLocalizations.of(context)!.avatar,
                user.avatar ?? AppLocalizations.of(context)!.not_available),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.close),
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
