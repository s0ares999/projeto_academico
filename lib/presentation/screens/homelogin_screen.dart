import 'package:flutter/material.dart';
import 'login_screen.dart'; // Importa a nova tela

class HomeLoginScreen extends StatefulWidget {
  const HomeLoginScreen({super.key});

  @override
  State<HomeLoginScreen> createState() => _HomeLoginScreenState();
}

class _HomeLoginScreenState extends State<HomeLoginScreen> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logoacademico.png',
                height: 200,
              ),
              const SizedBox(height: 30),
              const Text(
                'VIRIATOS SCOUTING',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              
              const SizedBox(height: 70),
              const Text(
                'Bem-vindo',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 237, 172, 43),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Onde o potencial encontra a oportunidade!',
                style: TextStyle(
                  fontSize: 19,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, 
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                    color: Colors.black, 
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
               Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: Colors.orange, // Borda laranja para o estado não selecionado
                  ),
                  child: Radio<String>(
                    value: 'accept_terms',
                    groupValue: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    activeColor: Colors.orange, // Cor de preenchimento quando selecionado
                  ),
                ),
                  const Text.rich(
                    TextSpan(
                      text: 'Aceito as ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      children: [
                        TextSpan(
                          text: 'políticas de privacidade',
                          style: TextStyle(
                            color: Color.fromARGB(255, 237, 172, 43),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
