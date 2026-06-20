import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blueAccent,
    colorScheme: const ColorScheme.light(
      primary: Colors.blueAccent,
      surface: Color(0xFFF8F9FA),
      onSurface: Color(0xFF212529),
      error: Color(0xFFDC3545),
      errorContainer: Color(0xFFF8D7DA),
      onErrorContainer: Color(0xFF842029),
      outline: Color(0x1F000000),
    ),
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF0F0F13),
    colorScheme: const ColorScheme.dark(
      primary: Colors.blueAccent,
      surface: Color(0xFF0F0F13),
      onSurface: Colors.white,
      error: Color(0xFFD32F2F),
      errorContainer: Color(0xFF2A1F1D),
      onErrorContainer: Colors.white,
      outline: Color(0x33FFFFFF),
    ),
    useMaterial3: true,
  );
}
