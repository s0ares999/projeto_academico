import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConsultarAtletaScreen extends StatefulWidget {
  const ConsultarAtletaScreen({super.key});

  @override
  _ConsultarAtletaScreenState createState() => _ConsultarAtletaScreenState();
}

class _ConsultarAtletaScreenState extends State<ConsultarAtletaScreen> {
  List<Map<String, dynamic>> athletes = [];
  List<Map<String, dynamic>> reports = [];
  final List<String> filters = ["Ano", "Posição", "Clube", "Rating"];
  int selectedFilter = 0;
  int selectedRating = 3;
  String selectedPosition = '';

  @override
  void initState() {
    super.initState();
    _fetchAthletes();
    _fetchReports();
  }

  Future<void> _fetchAthletes() async {
    const String url = 'https://pi4-hdnd.onrender.com/atletas';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);
        setState(() {
          athletes = List<Map<String, dynamic>>.from(decodedData);
        });
      } else {
        _showErrorDialog(
            'Erro ao carregar atletas. Código: ${response.statusCode}');
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
        _showErrorDialog(
            'Erro ao carregar relatórios. Código: ${response.statusCode}');
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

  int _getAthleteRating(String athleteId) {
    final report = reports.firstWhere(
      (report) => report['atleta_id'] == athleteId,
      orElse: () => {},
    );
    return report.isNotEmpty ? report['ratingFinalSelecionado'] ?? 0 : 0;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredAthletes = athletes;

    if (selectedRating != 3) {
      filteredAthletes = athletes.where((athlete) {
        return athlete['rating'] == selectedRating;
      }).toList();
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar atleta',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilter = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          filters[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: selectedFilter == index
                                ? Colors.orange
                                : Colors.black,
                          ),
                        ),
                        if (selectedFilter == index)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            height: 2,
                            width: 20,
                            color: Colors.orange,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredAthletes.length,
              itemBuilder: (context, index) {
                final athlete = filteredAthletes[index];
                final athleteRating = _getAthleteRating(
                    athlete['id'].toString()); // Obtendo rating do relatório

                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(athlete['nome']),
                    subtitle: Text(
                      'Clube: ${athlete['clube']}\nPosição: ${athlete['posicao']}\nAno: ${athlete['ano']}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('$athleteRating'),
                        const Icon(Icons.star, color: Colors.orange),
                      ],
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalhesAtletaScreen(
                            athlete: athlete, reports: [],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetalhesAtletaScreen extends StatelessWidget {
  final Map<String, dynamic> athlete;
  final List<Map<String, dynamic>> reports;

  const DetalhesAtletaScreen({
    required this.athlete,
    required this.reports,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Filtra os relatórios que pertencem ao atleta
    final athleteReports = reports.where((report) {
      return report['atleta_id'] == athlete['id'];
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(athlete['nome']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome: ${athlete['nome']}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Clube: ${athlete['clube']}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text('Posição: ${athlete['posicao']}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text('Ano: ${athlete['ano']}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              Text('Relatórios:', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              if (athleteReports.isEmpty)
                const Text('Nenhum relatório disponível para este atleta.', style: TextStyle(fontSize: 16)),
              if (athleteReports.isNotEmpty)
                Column(
                  children: athleteReports.map((report) {
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Título: ${report['titulo']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text('Data: ${report['data']}', style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 5),
                            Text('Observações: ${report['observacoes']}', style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 5),
                            Text('Rating: ${report['ratingFinalSelecionado']}', style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}