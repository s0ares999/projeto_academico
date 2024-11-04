import 'package:flutter/material.dart';

class CriarRelatorioScreen extends StatelessWidget {
  const CriarRelatorioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Relatório'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildSection('Técnica', 4),
            buildSection('Velocidade', 4),
            buildSection('Altura', 3, customOptions: ['Alto', 'Médio', 'Baixo']),
            buildSection('Atitude Competitiva', 4),
            buildSection('Inteligência', 4),
            buildSection('Morfologia', 3, customOptions: ['Ectomorfo', 'Mesomorfo', 'Endomorfo']),
            buildSection('Rating Final', 4),
            const SizedBox(height: 16),
            Text(
              'Observações',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Insira suas observações...',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Ação para submeter o relatório
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('SUBMETER', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection(String title, int options, {List<String>? customOptions}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: customOptions != null
                ? customOptions.map((opt) => buildRadioOption(opt)).toList()
                : List.generate(options, (index) => buildRadioOption((index + 1).toString())),
          ),
        ],
      ),
    );
  }

  Widget buildRadioOption(String label) {
    return Row(
      children: [
        Radio(
          value: label,
          groupValue: null,
          onChanged: (value) {},
          activeColor: Colors.orange,
        ),
        Text(label),
      ],
    );
  }
}