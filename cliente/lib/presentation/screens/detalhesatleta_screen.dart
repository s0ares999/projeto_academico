import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetalhesAtletaScreen extends StatelessWidget {
  final Map<String, dynamic> atleta;

  const DetalhesAtletaScreen({super.key, required this.atleta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(atleta['nome']),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CircleAvatar(
              radius: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Nome: ${atleta['nome']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Clube: ${atleta['clube']}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Posição: ${atleta['posicao']}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Data de Nascimento: ${atleta['data_nascimento']}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Rating: ${atleta['rating']}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Ação de voltar à tela anterior
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text('Voltar', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class ConsultarAtletaScreen extends StatefulWidget {
  const ConsultarAtletaScreen({super.key});

  @override
  _ConsultarAtletaScreenState createState() => _ConsultarAtletaScreenState();
}

class _ConsultarAtletaScreenState extends State<ConsultarAtletaScreen> {
  List<Map<String, dynamic>> athletes = [];
  List<Map<String, dynamic>> reports = [];

  @override
  void initState() {
    super.initState();
    _fetchAthletes(); // Busca os atletas
    _fetchReports(); // Busca os relatórios
  }

  Future<void> _fetchAthletes() async {
    const String url = 'https://pi4-hdnd.onrender.com/atletas';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Decodificar a resposta do servidor
        final List<dynamic> decodedData = json.decode(response.body);

        // Atualizar o estado com os dados
        setState(() {
          athletes = List<Map<String, dynamic>>.from(decodedData);
        });
      } else {
        _showErrorDialog('Erro ao carregar atletas. Código: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Erro de conexão: ${e.toString()}');
    }
  }

  Future<void> _fetchReports() async {
    const String url = 'https://pi4-hdnd.onrender.com/relatorios';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);

        setState(() {
          reports = List<Map<String, dynamic>>.from(decodedData);
        });
      } else {
        _showErrorDialog('Erro ao carregar relatórios. Código: ${response.statusCode}');
      }
    } catch (e) {
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultar Atletas'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: athletes.length,
        itemBuilder: (context, index) {
          final athlete = athletes[index];

          return GestureDetector(
            onTap: () {
              // Quando um atleta é clicado, navega para a página de detalhes
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalhesAtletaScreen(atleta: athlete),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(athlete['nome']),
                subtitle: Text(
                  'Clube: ${athlete['clube']}\nPosição: ${athlete['posicao']}',
                ),
                trailing: const Icon(Icons.arrow_forward),
              ),
            ),
          );
        },
      ),
    );
  }
}
