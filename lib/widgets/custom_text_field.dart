import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final Widget icon; // Untuk ikon pada awal input
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final bool autofocus;
  final FormFieldValidator<String>? validator; // Validator untuk field

  const CustomTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
    this.autofocus = false, // Untuk autofocus
    this.validator, // Untuk validasi
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      controller: controller,
      obscureText: obscureText, // Menangani teks tersembunyi atau tidak
      validator: validator, // Menambahkan validasi
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontFamily: 'Inter', color: Colors.grey),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10.0), // Jarak antara gambar dan tepi
          child: icon,
        ),
        suffixIcon: suffixIcon, // Menangani ikon di akhir input
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green, width: 2), // Border saat fokus
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1), // Border default
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[100], // Latar belakang text field
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12), // Padding dalam field
      ),
    );
  }
}
