import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final String? labelText; 
  final Widget icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final bool autofocus;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool enabled;

  const CustomTextField({
    super.key,
    this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.labelText, 
    this.controller,
    this.autofocus = false,
    this.validator,
    this.readOnly = false,
    this.keyboardType,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      readOnly: readOnly,
      keyboardType: keyboardType,
      enabled: enabled,
      // Tambahkan style agar teks input terlihat jelas
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: hint,
        // Tambahkan labelText yang selalu terlihat
        labelText: labelText ?? hint,
        // Pastikan label selalu terlihat
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: const TextStyle(fontFamily: 'Inter', color: Colors.grey),
        labelStyle: const TextStyle(
          fontFamily: 'Inter', 
          color: Colors.black54, 
          fontWeight: FontWeight.w500
        ),
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
        // Tambahkan disabledBorder
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        // Ubah warna latar belakang berdasarkan enabled
        fillColor: enabled ? Colors.grey[100] : Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
    );
  }
}