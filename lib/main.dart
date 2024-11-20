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
          theme: themeNotifier.themeData, // Usa o tema dinâmico baseado no ThemeNotifier
          darkTheme: themeNotifier.themeData, // Usa o mesmo tema para o modo escuro
          themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light, // Alterna entre os temas
          home: const SplashScreen(), // Definindo a SplashScreen como tela inicial
        );
      },
    );
  }
}
