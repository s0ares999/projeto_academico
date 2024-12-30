import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CriarRelatorioScreen extends StatefulWidget {
  const CriarRelatorioScreen({super.key});

  @override
  _CriarRelatorioScreenState createState() => _CriarRelatorioScreenState();
}

class _CriarRelatorioScreenState extends State<CriarRelatorioScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataNascimentoController = TextEditingController();
  final TextEditingController _nacionalidadeController = TextEditingController();
  final TextEditingController _posicaoController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _nomeAgenteController = TextEditingController();
  final TextEditingController _contactoAgenteController = TextEditingController();

  String? _clubeIdSelecionado;
  bool _criandoRelatorio = false;

  // Variáveis para os campos do relatório
  String? tecnicaSelecionada;
  String? velocidadeSelecionada;
  String? alturaSelecionada;
  String? atitudeSelecionada;
  String? inteligenciaSelecionada;
  String? morfologiaSelecionada;
  String? ratingFinalSelecionado;

  Future<void> _criarRelatorio() async {
    const String urlRelatorio = 'http://192.168.1.118:4100/relatorios';

    if (_nomeController.text.trim().isEmpty ||
        _dataNascimentoController.text.trim().isEmpty ||
        _nacionalidadeController.text.trim().isEmpty ||
        _posicaoController.text.trim().isEmpty ||
        _clubeIdSelecionado == null) {
      _showErrorDialog('Por favor, preencha todos os campos obrigatórios.');
      return;
    }

    // Dados do relatório
    final Map<String, dynamic> dadosRelatorio = {
      'tecnica': tecnicaSelecionada,
      'velocidade': velocidadeSelecionada,
      'atitudeCompetitiva': atitudeSelecionada,
      'inteligencia': inteligenciaSelecionada,
      'altura': alturaSelecionada,
      'morfologia': morfologiaSelecionada,
      'ratingFinal': ratingFinalSelecionado,
      'comentario': 'Relatório inicial',
      'atletaNome': _nomeController.text.trim(),
      'scoutId': 1, // Substitua pelo ID real do utilizador
      'status': 'Pendente',
    };

    try {
      setState(() {
        _criandoRelatorio = true;
      });

      // Criar o relatório
      final responseRelatorio = await http.post(
        Uri.parse(urlRelatorio),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dadosRelatorio),
      );

      if (responseRelatorio.statusCode == 201) {
        _showSuccessDialog('Relatório criado com sucesso!');
      } else {
        _showErrorDialog('Erro ao criar o relatório.');
      }
    } catch (e) {
      _showErrorDialog('Erro de conexão: ${e.toString()}');
    } finally {
      setState(() {
        _criandoRelatorio = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sucesso'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Relatório'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            // Campos para o relatório
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
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _criandoRelatorio ? null : _criarRelatorio,
              child: Text('Criar Relatório'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection(
      String title, int options, String? selectedValue, ValueChanged<String> onSelected,
      {List<String>? customOptions}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
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
          ),
          Text(label),
        ],
      ),
    );
  }
}
