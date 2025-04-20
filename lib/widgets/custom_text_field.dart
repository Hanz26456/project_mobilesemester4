import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final Widget icon; // Menggunakan Widget untuk menerima Image atau Icon
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final bool autofocus;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
    this.autofocus = false, // Menambahkan opsi autofocus
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autofocus,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontFamily: 'Inter', color: Colors.grey),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10.0), // Memberikan jarak antara gambar dan tepi
          child: icon,
        ),
        suffixIcon: suffixIcon,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green, width: 2), // Efek border saat fokus
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1), // Border default
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[100], // Warna latar belakang
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12), // Padding dalam field
      ),
    );
  }
}
