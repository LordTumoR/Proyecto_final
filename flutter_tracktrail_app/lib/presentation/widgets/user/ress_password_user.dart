import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/auth/login_event.dart';

class RessPasswordDialog extends StatefulWidget {
  @override
  _RessPasswordDialogState createState() => _RessPasswordDialogState();
}

class _RessPasswordDialogState extends State<RessPasswordDialog> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Recuperar Contraseña'),
      content: TextField(
        controller: _emailController,
        decoration: const InputDecoration(
          labelText: 'Email',
          hintText: 'Introduce tu email',
        ),
        keyboardType: TextInputType.emailAddress,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
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
                const SnackBar(
                    content: Text('Por favor, introduce un email válido')),
              );
            }
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
