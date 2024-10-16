import 'package:flutter/material.dart';
import '/presentation/screens/splash_screen.dart'; // Adiciona a importação da SplashScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Academico de Viseu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // Definindo a SplashScreen como tela inicial
    );
  }
}