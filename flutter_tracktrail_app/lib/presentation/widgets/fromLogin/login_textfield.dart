import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.isPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.8,
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.black
            .withOpacity(0.6), // Fondo más oscuro para mayor contraste
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Shadow direction
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(
          color: Colors.white, // Color del texto blanco para contraste
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.white.withOpacity(0.8),
          ),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color:
                Colors.white.withOpacity(0.7), // Color más claro para el hint
          ),
        ),
      ),
    );
  }
}
