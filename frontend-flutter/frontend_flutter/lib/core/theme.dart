import 'package:flutter/material.dart';

class AppTheme {
  // seed color (primary-ish)
  static const Color seed = Color(0xFF1565C0);

  static ThemeData light() {
    final lightScheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light)
        .copyWith(secondary: const Color(0xFF64B5F6));
    return ThemeData(
      colorScheme: lightScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightScheme.secondary,
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: lightScheme.secondary,
        foregroundColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightScheme.secondary,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
    );
  }

  static ThemeData dark() {
    final darkScheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark)
        .copyWith(secondary: const Color(0xFF90CAF9));
    return ThemeData(
      colorScheme: darkScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.black,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkScheme.secondary,
          foregroundColor: Colors.black,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkScheme.secondary,
        foregroundColor: Colors.black,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkScheme.secondary,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
    );
  }
}