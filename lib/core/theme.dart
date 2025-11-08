import 'package:flutter/material.dart';

// Você pode mudar esta cor para qualquer uma que desejar
final Color corPrimaria = Colors.indigo;
final Color corSecundaria = Colors.indigo.shade400;

final ThemeData appTheme = ThemeData(
  // Define o esquema de cores
  colorScheme: ColorScheme.fromSeed(
    seedColor: corPrimaria,
    primary: corPrimaria,
    secondary: corSecundaria,
    brightness: Brightness.light,
  ),

  // Tema da AppBar
  appBarTheme: AppBarTheme(
    backgroundColor: corPrimaria,
    foregroundColor: Colors.white, // Cor do título e ícones
    elevation: 4,
  ),

  // Tema do FloatingActionButton
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: corSecundaria,
    foregroundColor: Colors.white,
  ),

  // Tema dos Botões Elevados
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: corPrimaria,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),

  // Tema dos Campos de Texto
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: corPrimaria, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
  ),

  useMaterial3: true,
);
