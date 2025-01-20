import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CriarRelatorioScreen extends StatefulWidget {
  const CriarRelatorioScreen({super.key});

  @override
  _CriarRelatorioScreenState createState() => _CriarRelatorioScreenState();
}

class _CriarRelatorioScreenState extends State<CriarRelatorioScreen> {
  final TextEditingController _comentarioController = TextEditingController();
  String? _atletaNomeSelecionado;
  bool _criandoRelatorio = false;

  List<dynamic> _atletas = [];

  // Variáveis para os campos do relatório
  String? tecnicaSelecionada;
  String? velocidadeSelecionada;
  String? alturaSelecionada;
  String? atitudeSelecionada;
  String? inteligenciaSelecionada;
  String? morfologiaSelecionada;
  String? ratingFinalSelecionado;

  @override
  void initState() {
    super.initState();
    _carregarAtletas();
  }

  Future<void> _carregarAtletas() async {
    const String urlAtletas = 'http://192.168.1.118:3000/atletas';
    try {
      final response = await http.get(Uri.parse(urlAtletas));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _atletas = data;
        });
        print('Atletas carregados: $_atletas');
      } else {
        _showErrorDialog(
            'Erro ao carregar atletas. Código: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Erro de conexão: ${e.toString()}');
      print('Erro ao carregar atletas: $e');
    }
  }

  Future<String?> _obterToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<int?> _obterUserId(String? token) async {
    if (token == null || token.isEmpty) {
      return null;
    }
    final parts = token.split('.');
    if (parts.length != 3) {
      return null;
    }
    try {
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      return payload['id'] as int?;
    } catch (e) {
      return null;
    }
  }

  Future<void> _criarRelatorio() async {
    const String urlRelatorio = 'http://192.168.1.118:3000/relatorios';

    try {
      setState(() {
        _criandoRelatorio = true;
      });

      final token = await _obterToken();
      final userId = await _obterUserId(token);

      if (userId == null) {
        _showErrorDialog('Erro: Utilizador não autenticado ou token inválido.');
        return;
      }

      final Map<String, dynamic> dadosRelatorio = {
        'tecnica': tecnicaSelecionada ?? '0',
        'velocidade': velocidadeSelecionada ?? '0',
        'atitudeCompetitiva': atitudeSelecionada ?? '0',
        'inteligencia': inteligenciaSelecionada ?? '0',
        'altura': alturaSelecionada ?? '0',
        'morfologia': morfologiaSelecionada ?? '0',
        'ratingFinal': int.tryParse(ratingFinalSelecionado ?? '0'),
        'comentario': _comentarioController.text.isEmpty
            ? 'Nenhum comentário.'
            : _comentarioController.text,
        'atletaNome': _atletaNomeSelecionado, // Envia o nome do atleta
        'scoutId': userId,
        'status': 'pendente',
      };

      final responseRelatorio = await http.post(
        Uri.parse(urlRelatorio),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(dadosRelatorio),
      );

      if (responseRelatorio.statusCode == 201) {
        _showSuccessDialog('Relatório criado com sucesso!');
      } else {
        _showErrorDialog(
            'Erro ao criar o relatório: ${responseRelatorio.body}');
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
        title: const Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sucesso'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Relatório'),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            DropdownButton<String>(
              value: _atletaNomeSelecionado,
              hint: const Text('Selecione o Atleta'),
              onChanged: (String? newValue) {
                setState(() {
                  _atletaNomeSelecionado = newValue;
                });
              },
              items: _atletas
                  .where((atleta) => atleta != null && atleta['nome'] != null)
                  .map<DropdownMenuItem<String>>((atleta) {
                return DropdownMenuItem<String>(
                  value: atleta['nome'].toString(),
                  child: Text(atleta['nome']),
                );
              }).toList(),
            ),
            buildSection('Técnica', 4, tecnicaSelecionada,
                (value) => setState(() => tecnicaSelecionada = value)),
            buildSection('Velocidade', 4, velocidadeSelecionada,
                (value) => setState(() => velocidadeSelecionada = value)),
            buildSection('Altura', 3, alturaSelecionada,
                (value) => setState(() => alturaSelecionada = value),
                customOptions: ['alto', 'medio', 'baixo']),
            buildSection('Atitude Competitiva', 4, atitudeSelecionada,
                (value) => setState(() => atitudeSelecionada = value)),
            buildSection('Inteligência', 4, inteligenciaSelecionada,
                (value) => setState(() => inteligenciaSelecionada = value)),
            buildSection('Morfologia', 3, morfologiaSelecionada,
                (value) => setState(() => morfologiaSelecionada = value),
                customOptions: ['ectomorfo', 'mesomorfo', 'endomorfo']),
            buildSection('Rating Final', 5, ratingFinalSelecionado,
                (value) => setState(() => ratingFinalSelecionado = value)),
            const SizedBox(height: 16),
            TextField(
              controller: _comentarioController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Comentário',
                border: OutlineInputBorder(),
                hintText: 'Adicione um comentário...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _criandoRelatorio ? null : _criarRelatorio,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text('Criar Relatório'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection(String title, int options, String? selectedValue,
      ValueChanged<String> onSelected,
      {List<String>? customOptions}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 10.0,
          children: customOptions != null
              ? customOptions
                  .map(
                      (opt) => buildRadioOption(opt, selectedValue, onSelected))
                  .toList()
              : List.generate(
                  options,
                  (index) => buildRadioOption(
                      (index + 1).toString(), selectedValue, onSelected)),
        ),
      ],
    );
  }

  Widget buildRadioOption(
      String label, String? selectedValue, ValueChanged<String> onSelected) {
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
