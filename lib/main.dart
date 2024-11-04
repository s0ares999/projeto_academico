import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importa o Provider
import '/presentation/screens/splash_screen.dart'; // Adiciona a importação da SplashScreen
import 'theme_notifier.dart'; // Importa o ThemeNotifier

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(), // Cria o ThemeNotifier
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Académico de Viseu',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light, // Tema claro
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.orange, // Tema escuro
            brightness: Brightness.dark,
          ),
          themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light, // Alterna entre os temas
          home: const SplashScreen(), // Definindo a SplashScreen como tela inicial
        );
      },
    );
  }
}
