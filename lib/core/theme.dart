import 'package:flutter/material.dart';

class AppTheme {
  // Cores Extraídas do Figma
  static const Color background = Color(0xFF0D1117); // Fundo escuro principal
  static const Color surface = Color(0xFF161B22); // Fundo dos cards e inputs
  static const Color primary = Color(0xFF3B82F6); // Azul vibrante dos botões
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF8B949E);
  
  // Cores Semânticas
  static const Color success = Color(0xFF10B981); // Verde
  static const Color warning = Color(0xFFF59E0B); // Amarelo/Laranja
  static const Color error = Color(0xFFEF4444); // Vermelho

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        surface: surface,
        background: background,
        error: error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface, // Fundo permanente mais claro
        elevation: 2, // Elevação fixa
        shadowColor: Colors.black54, // Sombra sutil permanente
        surfaceTintColor: primary, // O leve tom azulado constante
        scrolledUnderElevation: 0, // Desativa a mudança no scroll
      ),
      fontFamily: 'Inter', // Fonte limpa (padrão)
      
      // Estilo dos Botões
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      // Estilo dos Inputs (TextFields)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: const TextStyle(color: textSecondary),
        labelStyle: const TextStyle(color: textPrimary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      // Estilo dos Cards
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
