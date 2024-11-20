// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CriarRelatorioScreen extends StatefulWidget {
  const CriarRelatorioScreen({super.key});

  @override
  _CriarRelatorioScreenState createState() => _CriarRelatorioScreenState();
}

class _CriarRelatorioScreenState extends State<CriarRelatorioScreen> {
  // Variáveis de estado para armazenar as seleções de cada seção
  String? tecnicaSelecionada;
  String? velocidadeSelecionada;
  String? alturaSelecionada;
  String? atitudeSelecionada;
  String? inteligenciaSelecionada;
  String? morfologiaSelecionada;
  String? ratingFinalSelecionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Relatório', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            buildSection('Técnica', 4, tecnicaSelecionada,
                (value) => setState(() => tecnicaSelecionada = value)),
            buildSection('Velocidade', 4, velocidadeSelecionada,
                (value) => setState(() => velocidadeSelecionada = value)),
            buildSection('Altura', 3, alturaSelecionada,
                (value) => setState(() => alturaSelecionada = value),
                customOptions: ['Alto', 'Médio', 'Baixo']),
            buildSection('Atitude Competitiva', 4, atitudeSelecionada,
                (value) => setState(() => atitudeSelecionada = value)),
            buildSection('Inteligência', 4, inteligenciaSelecionada,
                (value) => setState(() => inteligenciaSelecionada = value)),
            buildSection('Morfologia', 3, morfologiaSelecionada,
                (value) => setState(() => morfologiaSelecionada = value),
                customOptions: ['Ectomorfo', 'Mesomorfo', 'Endomorfo']),
            buildSection('Rating Final', 4, ratingFinalSelecionado,
                (value) => setState(() => ratingFinalSelecionado = value)),
            const SizedBox(height: 12),
            Text(
              'Observações',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Insira suas observações...',
                isDense: true,
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Ação para submeter o relatório
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text('SUBMETER', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection(
      String title, int options, String? selectedValue, ValueChanged<String> onSelected,
      {List<String>? customOptions}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 10.0,
            children: customOptions != null
                ? customOptions
                    .map((opt) => buildRadioOption(opt, selectedValue, onSelected))
                    .toList()
                : List.generate(
                    options,
                    (index) => buildRadioOption((index + 1).toString(), selectedValue, onSelected)),
          ),
        ],
      ),
    );
  }

  Widget buildRadioOption(String label, String? selectedValue, ValueChanged<String> onSelected) {
    return GestureDetector(
      onTap: () => onSelected(label),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: label,
            groupValue: selectedValue,
            onChanged: (value) => onSelected(value!),
            activeColor: Colors.orange,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
