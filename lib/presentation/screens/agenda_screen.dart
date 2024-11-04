import 'package:flutter/material.dart';

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AGENDA'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'League',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  buildMatchCard('Red Devils', 'V. Greens', '9 Jan 2021', '19.45', 'assets/images/logo_red.png', 'assets/images/logo_green.png'),
                  buildMatchCard('V. Greens', 'R. Birds', '11 Jan 2021', '19.45', 'assets/images/logo_green.png', 'assets/images/logo_red.png'),
                  buildMatchCard('V. Greens', 'B. Monkeys', '15 Jan 2021', '19.45', 'assets/images/logo_green.png', 'assets/images/logo_monkey.png'),
                  buildMatchCard('Red Devils', 'V. Greens', '18 Jan 2021', '19.45', 'assets/images/logo_red.png', 'assets/images/logo_green.png'),
                  buildMatchCard('V. Greens', 'R. Birds', '24 Jan 2021', '19.45', 'assets/images/logo_green.png', 'assets/images/logo_red.png'),
                  buildMatchCard('V. Greens', 'B. Monkeys', '30 Jan 2021', '19.45', 'assets/images/logo_green.png', 'assets/images/logo_monkey.png'),
                  buildMatchCard('V. Greens', 'B. Monkeys', '9 Feb 2021', '19.45', 'assets/images/logo_green.png', 'assets/images/logo_monkey.png'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget buildMatchCard(String team1, String team2, String date, String time, String logo1, String logo2) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max, // O Row vai ocupar o espaço disponível horizontalmente
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Garante espaçamento adequado
        children: [
          // Coluna da equipa 1
          Column(
            children: [
              Image.asset(logo1, height: 50),
              const SizedBox(height: 8),
              Text(
                team1,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),

          // Conteúdo central (equipa vs equipa e data)
          Expanded( // O conteúdo central expande-se conforme necessário
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$team1 vs $team2',
                  style: const TextStyle(
                    fontSize: 14, // Diminuí o tamanho da fonte
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center, // Centraliza o texto
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Centraliza os ícones e texto
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      '9 Jan 2021', // Exemplo de data
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // Diminuí o tamanho da fonte
                  ),
                ),
              ],
            ),
          ),

          // Coluna da equipa 2
          Column(
            children: [
              Image.asset(logo2, height: 50),
              const SizedBox(height: 8),
              Text(
                team2,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}