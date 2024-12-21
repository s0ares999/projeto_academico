// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get themeData {
    return _isDarkMode ? _darkTheme() : _lightTheme();
  }

  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black), // Atualizado para 'bodyLarge'
        bodyMedium: TextStyle(color: Colors.black), // Atualizado para 'bodyMedium'
        bodySmall: TextStyle(color: Colors.black), // Atualizado para 'bodySmall'
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(color: Colors.black),
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white), // Atualizado para 'bodyLarge'
        bodyMedium: TextStyle(color: Colors.white), // Atualizado para 'bodyMedium'
        bodySmall: TextStyle(color: Colors.white), // Atualizado para 'bodySmall'
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        titleTextStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}
