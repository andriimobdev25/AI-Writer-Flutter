import 'package:flutter/material.dart';

class AppTheme {
  // LinkedIn brand colors
  static const Color linkedinBlue = Color(0xFF0A66C2);
  static const Color linkedinLightBlue = Color(0xFF70B5F9);
  static const Color linkedinDarkBlue = Color(0xFF004182);
  static const Color linkedinGray = Color(0xFF86888A);
  static const Color linkedinLightGray = Color(0xFFF3F2EF);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: linkedinBlue,
        secondary: linkedinLightBlue,
        surface: linkedinLightGray,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: linkedinBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      scaffoldBackgroundColor: linkedinLightGray,
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: linkedinDarkBlue,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black87),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: linkedinBlue, width: 2),
        ),
      ),
    );
  }
}
