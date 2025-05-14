import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final Widget icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final bool autofocus;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool enabled; // 🔹 Tambahkan ini

  const CustomTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
    this.autofocus = false,
    this.validator,
    this.keyboardType,
    this.enabled = true, // 🔹 Default true
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      enabled: enabled, // 🔹 Tambahkan ini
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontFamily: 'Inter', color: Colors.grey),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: icon,
        ),
        suffixIcon: suffixIcon,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
    );
  }
}
