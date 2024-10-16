import 'package:flutter/material.dart';
import 'login_screen.dart'; // Importa a nova tela

class HomeLoginScreen extends StatelessWidget {
  const HomeLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Remover o título da AppBar
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255), // Cor inicial do gradiente
              Color.fromARGB(255, 255, 255, 255) // Cor final do gradiente
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logoacademico.png',
                height: 150, // Ajuste o tamanho da imagem
              ),
              const SizedBox(height: 15),
              const Text(
                'Académico de Viseu', // Primeira linha do título
                textAlign: TextAlign.center, // Centraliza o texto
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0), // Cor do texto
                ),
              ),
              const Text(
                'Futebol Clube', // Segunda linha do título
                textAlign: TextAlign.center, // Centraliza o texto
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0), // Cor do texto
                ),
              ),
              const SizedBox(height: 70),
              const Text(
                'Bem-vindo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0), // Cor do texto
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Onde o potencial encontra a qualidade',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 0, 0, 0), // Cor do texto
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  // Navega para a tela de login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(218, 218, 218, 218), // Cor de fundo do botão
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255), // Cor do texto do botão
                  ),
                ),
                child: const Text('LOGIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
