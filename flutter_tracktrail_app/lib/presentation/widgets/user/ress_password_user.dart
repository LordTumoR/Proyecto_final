import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RessPasswordDialog extends StatefulWidget {
  @override
  _RessPasswordDialogState createState() => _RessPasswordDialogState();
}

class _RessPasswordDialogState extends State<RessPasswordDialog> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.reset_password),
      content: TextField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.email,
          hintText: AppLocalizations.of(context)!.enter_your_email,
        ),
        keyboardType: TextInputType.emailAddress,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () {
            final email = _emailController.text.trim();
            if (email.isNotEmpty) {
              context
                  .read<LoginBloc>()
                  .add(ResetPasswordButtonPressed(email: email));
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(AppLocalizations.of(context)!
                        .please_enter_valid_email)),
              );
            }
          },
          child: Text(AppLocalizations.of(context)!.accept),
        ),
      ],
    );
  }
}
