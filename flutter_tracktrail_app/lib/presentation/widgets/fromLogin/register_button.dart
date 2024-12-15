import 'dart:ui';
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RegisterButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onPressed,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.8,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 35, 36, 36).withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Register',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
