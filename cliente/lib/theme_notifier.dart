import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Notifica os ouvintes para atualizar o tema
  }

  ThemeData get themeData {
    return _isDarkMode ? _darkTheme() : _lightTheme();
  }

  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blue, // Cor do botão
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Cor de fundo do botão
          foregroundColor: Colors.white, // Cor do texto do botão
        ),
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blueGrey,
      scaffoldBackgroundColor: Colors.black,
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white, // Cor da AppBar no modo escuro
        titleTextStyle: TextStyle(color: Colors.black),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blueGrey, // Cor do botão
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey, // Cor de fundo do botão
          foregroundColor: Colors.white, // Cor do texto do botão
        ),
      ),
    );
  }
}
