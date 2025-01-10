import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final int completionPercentage;

  const ProgressDialog({Key? key, required this.completionPercentage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('METAS Y PROGRESO'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Porcentaje completado: $completionPercentage%",
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
