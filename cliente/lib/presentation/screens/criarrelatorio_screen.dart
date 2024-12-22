// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CriarAtletaScreen extends StatefulWidget {
  const CriarAtletaScreen({super.key});

  @override
  _CriarAtletaScreenState createState() => _CriarAtletaScreenState();
}

class _CriarAtletaScreenState extends State<CriarAtletaScreen> {
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

  Future<void> _criarAtletaComRelatorio() async {
    const String urlAtleta = 'http://192.168.1.73:4000/atletas';
    const String urlRelatorio = 'http://192.168.1.73:4000/relatorios';

    if (_nomeController.text.trim().isEmpty ||
        _dataNascimentoController.text.trim().isEmpty ||
        _nacionalidadeController.text.trim().isEmpty ||
        _posicaoController.text.trim().isEmpty ||
        _clubeIdSelecionado == null) {
      _showErrorDialog('Por favor, preencha todos os campos obrigatórios.');
      return;
    }

    final Map<String, dynamic> dadosAtleta = {
      'nome': _nomeController.text.trim(),
      'dataNascimento': _dataNascimentoController.text.trim(),
      'nacionalidade': _nacionalidadeController.text.trim(),
      'posicao': _posicaoController.text.trim(),
      'clube': _clubeIdSelecionado,
      'link': _linkController.text.trim(),
      'agente': _nomeAgenteController.text.trim(),
      'contactoAgente': _contactoAgenteController.text.trim(),
    };

    try {
      setState(() {
        _criandoRelatorio = true;
      });

      // Criar o atleta
      final responseAtleta = await http.post(
        Uri.parse(urlAtleta),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dadosAtleta),
      );

      if (responseAtleta.statusCode == 201) {
        final atletaCriado = jsonDecode(responseAtleta.body);

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
          'atletaNome': atletaCriado['nome'], // Nome do atleta
          'scoutId': 1, // Substitua pelo ID real do utilizador
          'status': 'Pendente',
        };

        // Criar o relatório associado ao atleta
        final responseRelatorio = await http.post(
          Uri.parse(urlRelatorio),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(dadosRelatorio),
        );

        if (responseRelatorio.statusCode == 201) {
          _showSuccessDialog('Atleta e relatório criados com sucesso!');
        } else {
          _showErrorDialog('Erro ao criar o relatório.');
        }
      } else {
        _showErrorDialog('Erro ao criar o atleta.');
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
        title: Text('Criar Atleta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            // Campos de criação do atleta
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _dataNascimentoController,
              decoration: InputDecoration(labelText: 'Data de Nascimento'),
            ),
            TextField(
              controller: _nacionalidadeController,
              decoration: InputDecoration(labelText: 'Nacionalidade'),
            ),
            TextField(
              controller: _posicaoController,
              decoration: InputDecoration(labelText: 'Posição'),
            ),
            DropdownButton<String>(
              value: _clubeIdSelecionado,
              hint: Text('Selecione o clube'),
              items: [
                DropdownMenuItem(value: '1', child: Text('Clube A')),
                DropdownMenuItem(value: '2', child: Text('Clube B')),
              ],
              onChanged: (value) {
                setState(() {
                  _clubeIdSelecionado = value;
                });
              },
            ),
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
              onPressed: _criandoRelatorio ? null : _criarAtletaComRelatorio,
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
