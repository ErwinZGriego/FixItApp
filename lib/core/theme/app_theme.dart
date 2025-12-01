import 'package:flutter/material.dart';

class AppTheme {
  // Colores Base (Inspirados en UTH)
  static const Color primaryColor = Color(0xFF009B77); // Verde Institucional
  static const Color secondaryColor = Color(0xFFE85E21); // Naranja/Acento
  static const Color scaffoldBackground = Color(
    0xFFF5F5F5,
  ); // Fondo gris muy claro

  // Definición del Tema Claro
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // Definición de esquema de colores
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: Colors.white,
        // Eliminamos 'background' aquí porque está obsoleto.
        // El color de fondo se define abajo en scaffoldBackgroundColor.
      ),

      // Fondo de las pantallas por defecto
      scaffoldBackgroundColor: scaffoldBackground,

      // Estilo global del AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white, // Color de texto e iconos
        centerTitle: true,
        elevation: 0,
      ),

      // Estilo global de Botones Elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      // Estilo global de Inputs (Cajas de texto)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }
}
