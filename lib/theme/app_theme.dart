import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2A9D8F);
  static const Color secondaryColor = Color(0xFFE9C46A);
  static const Color accentColor = Color(0xFFE76F51);
  static const Color neutralDark = Color(0xFF264653);
  static const Color neutralLight = Color(0xFFF4F1DE);

  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);

  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundWhite = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF2A9D8F);
  static const Color error = Color(0xFFE76F51);
  static const Color warning = Color(0xFFE9C46A);
  static const Color info = Color(0xFF2A9D8F);

  static ThemeData lightTheme() {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundLight,
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
        bodySmall: TextStyle(color: textLight),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      ),
    );
  }
}
