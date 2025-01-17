import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pi4_academico/presentation/screens/home_screen.dart';

class CriarAtletaScreen extends StatefulWidget {
  const CriarAtletaScreen({super.key});

  @override
  _CriarAtletaScreenState createState() => _CriarAtletaScreenState();
}

class _CriarAtletaScreenState extends State<CriarAtletaScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  final TextEditingController _nacionalidadeController =
      TextEditingController();
  final TextEditingController _posicaoController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _nomeAgenteController = TextEditingController();
  final TextEditingController _contactoAgenteController =
      TextEditingController();

  String? _clubeIdSelecionado;
  List<Map<String, dynamic>> _clubes = [];

  @override
  void initState() {
    super.initState();
    _carregarClubes();
  }

  Future<void> _carregarClubes() async {
    const String url = 'http://192.168.0.27:3000/times';
    print('Iniciando o carregamento dos clubes...');
    try {
      final response = await http.get(Uri.parse(url));
      print('Resposta recebida da API: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> clubesJson = jsonDecode(response.body);
        print('Clubes carregados: $clubesJson');
        setState(() {
          _clubes = clubesJson.cast<Map<String, dynamic>>();
        });
      } else {
        print('Erro ao carregar clubes. Status: ${response.statusCode}');
        _showErrorDialog(
            'Erro ao carregar clubes. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição de clubes: $e');
      _showErrorDialog('Erro de conexão: $e');
    }
  }

  Future<void> _criarAtleta() async {
    const String url = 'http://192.168.0.27:3000/atletas';
    print('Iniciando a criação do atleta...');

    if (_nomeController.text.trim().isEmpty ||
        _dataNascimentoController.text.trim().isEmpty ||
        _nacionalidadeController.text.trim().isEmpty ||
        _posicaoController.text.trim().isEmpty ||
        _clubeIdSelecionado == null) {
      print('Erro: Campos obrigatórios faltando');
      _showErrorDialog('Por favor, preencha todos os campos obrigatórios.');
      return;
    }

    final DateFormat backendFormat = DateFormat('dd/MM/yyyy');
    final String formattedDate =
        backendFormat.format(DateTime.parse(_dataNascimentoController.text));

    final Map<String, dynamic> dadosAtleta = {
      'nome': _nomeController.text.trim(),
      'dataNascimento': formattedDate,
      'nacionalidade': _nacionalidadeController.text.trim(),
      'posicao': _posicaoController.text.trim(),
      'clube': _clubeIdSelecionado,
      'link': _linkController.text.trim(),
      'agente': _nomeAgenteController.text.trim(),
      'contactoAgente': _contactoAgenteController.text.trim(),
    };

    print('Dados enviados ao backend: ${jsonEncode(dadosAtleta)}');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dadosAtleta),
      );
      print(
          'Resposta da API: Status ${response.statusCode}, Corpo: ${response.body}');
      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('Atleta criado com sucesso: $responseData');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sucesso'),
              content: Text(
                  'Atleta criado com sucesso! ${responseData['mensagem'] ?? 'Ele está pendente de aprovação.'}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fecha o diálogo
                    Navigator.of(context).pop(); // Fecha o diálogo
                    // Navega diretamente para a HomeScreen
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (Route<dynamic> route) =>
                          false, // Remove todas as rotas anteriores
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        final errorData = jsonDecode(response.body);
        print(
            'Erro ao criar atleta: ${errorData['mensagem'] ?? 'Erro desconhecido.'}');
        _showErrorDialog(
            'Erro ao criar atleta: ${errorData['mensagem'] ?? 'Erro desconhecido.'}');
      }
    } catch (e) {
      print('Erro durante a criação do atleta: $e');
      _showErrorDialog('Erro de conexão: ${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _escolherDataNascimento() async {
    DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (dataEscolhida != null) {
      setState(() {
        _dataNascimentoController.text =
            '${dataEscolhida.year}-${dataEscolhida.month.toString().padLeft(2, '0')}-${dataEscolhida.day.toString().padLeft(2, '0')}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField('Nome', _nomeController),
              const SizedBox(height: 10),
              _buildDatePickerField(
                  'Data de Nascimento', _dataNascimentoController),
              const SizedBox(height: 10),
              _buildTextField('Nacionalidade', _nacionalidadeController),
              const SizedBox(height: 10),
              _buildTextField('Posição', _posicaoController),
              const SizedBox(height: 10),
              _buildDropdownField('Clube', _clubeIdSelecionado, _clubes),
              const SizedBox(height: 10),
              _buildTextField('Link', _linkController),
              const SizedBox(height: 10),
              _buildTextField('Nome do Agente', _nomeAgenteController),
              const SizedBox(height: 10),
              _buildTextField('Contato do Agente', _contactoAgenteController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _criarAtleta,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Criar Atleta',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: _escolherDataNascimento,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.orange),
      ),
    );
  }

  Widget _buildDropdownField(
      String label, String? value, List<Map<String, dynamic>> items) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text('Selecione $label'),
      onChanged: (String? novoValor) {
        setState(() {
          _clubeIdSelecionado = novoValor;
        });
      },
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item['nome'], // Aqui passamos o nome em vez do id
          child: Text(item['nome']),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
