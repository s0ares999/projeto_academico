// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'homelogin_screen.dart'; // Importa a tela HomeLoginScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHomeLogin();
  }

  _navigateToHomeLogin() async {
    await Future.delayed(Duration(seconds: 3), () {}); // Tempo para exibir a splash screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeLoginScreen(), // Redireciona para a tela HomeLoginScreen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(1, 218, 218, 218), // Cor de fundo desejada
      body: Center(
        child: Image.asset('assets/images/logoacademico.png', width: 150), // Caminho do logo
      ),
    );
  }
}
