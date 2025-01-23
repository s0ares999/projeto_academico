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
  String searchQuery = '';
  bool isAscending = true;

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
        if (mounted) {
          setState(() {
            athletes = List<Map<String, dynamic>>.from(decodedData.map((atleta) {
              return {
                'id': atleta['id'] ?? 0,
                'nome': atleta['nome'] ?? 'Nome não disponível',
                'clube': atleta['clube'] ?? 'Clube não disponível',
                'posicao': atleta['posicao'] ?? 'Posição não disponível',
                'ano': atleta['ano'] ?? 0,
              };
            }));
          });
        }
      } else {
        if (mounted) {
          _showErrorDialog(
              'Erro ao carregar atletas. Código: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Erro de conexão: ${e.toString()}');
      }
    }
  }

  Future<void> _fetchReports() async {
    const String url = 'https://pi4-hdnd.onrender.com/relatorios';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);
        if (mounted) {
          setState(() {
            reports = List<Map<String, dynamic>>.from(decodedData);
          });
        }
        print('Relatórios recebidos: ${response.body}'); // Depuração
      } else {
        if (mounted) {
          _showErrorDialog(
              'Erro ao carregar relatórios. Código: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Erro de conexão: ${e.toString()}');
      }
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
      (report) => report['atletaId'].toString() == athleteId,
      orElse: () => {},
    );
    return report.isNotEmpty ? report['ratingFinal'] ?? 0 : 0;
  }

  List<Map<String, dynamic>> _filterAthletes() {
    List<Map<String, dynamic>> filteredAthletes = athletes;

    // Filtro por pesquisa
    if (searchQuery.isNotEmpty) {
      filteredAthletes = filteredAthletes.where((athlete) {
        return athlete['nome']
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
      }).toList();
    }

    // Filtro por posição
    if (selectedFilter == 1 && selectedPosition.isNotEmpty) {
      filteredAthletes = filteredAthletes.where((athlete) {
        return athlete['posicao'] == selectedPosition;
      }).toList();
    }

    // Filtro por rating
    if (selectedFilter == 3) {
      filteredAthletes = filteredAthletes.where((athlete) {
        final athleteRating = _getAthleteRating(athlete['id'].toString());
        return athleteRating == selectedRating;
      }).toList();
    }

    return filteredAthletes;
  }

  List<Map<String, dynamic>> _sortAthletes(List<Map<String, dynamic>> athletes) {
    if (selectedFilter == 0) {
      // Ordenar por ano
      athletes.sort((a, b) => isAscending
          ? (a['ano'] ?? 0).compareTo(b['ano'] ?? 0)
          : (b['ano'] ?? 0).compareTo(a['ano'] ?? 0));
    } else if (selectedFilter == 2) {
      // Ordenar por clube
      athletes.sort((a, b) => isAscending
          ? (a['clube'] ?? '').compareTo(b['clube'] ?? '')
          : (b['clube'] ?? '').compareTo(a['clube'] ?? ''));
    }

    return athletes;
  }

  void _showPositionModal() {
    final positions = [
      'Guarda-Redes',
      'Defesa Central',
      'Defesa Esquerda',
      'Defesa Direita',
      'Médio',
      'Atacante',
    ]; // Exemplo de posições

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: positions.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(positions[index]),
              onTap: () {
                setState(() {
                  selectedPosition = positions[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _showRatingModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: List.generate(5, (index) {
            final rating = index + 1;
            return ListTile(
              title: Text('Rating $rating'),
              onTap: () {
                setState(() {
                  selectedRating = rating;
                });
                Navigator.pop(context);
              },
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredAthletes = _filterAthletes();
    filteredAthletes = _sortAthletes(filteredAthletes);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
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
                      if (index == 1) {
                        _showPositionModal();
                      } else if (index == 3) {
                        _showRatingModal();
                      } else if (index == 0 || index == 2) {
                        isAscending = !isAscending;
                      }
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
                            athlete: athlete,
                            reports: reports,
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

  DetalhesAtletaScreen({
    Key? key,
    required this.athlete,
    required this.reports,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> athleteReport = reports.firstWhere(
      (report) => report['atletaId'].toString() == athlete['id'].toString(),
      orElse: () => {},
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(athlete['nome']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Nome: ${athlete['nome']}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Clube: ${athlete['clube']}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Posição: ${athlete['posicao']}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Ano: ${athlete['ano']}',
                style: const TextStyle(fontSize: 16)),
            const Divider(height: 30),
            const Text(
              'Dados do Relatório:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Técnica: ${athleteReport['tecnica'] ?? 'N/A'}'),
            Text('Velocidade: ${athleteReport['velocidade'] ?? 'N/A'}'),
            Text('Atitude Competitiva: ${athleteReport['atitudeCompetitiva'] ?? 'N/A'}'),
            Text('Inteligência: ${athleteReport['inteligencia'] ?? 'N/A'}'),
            Text('Altura: ${athleteReport['altura'] ?? 'N/A'}'),
            Text('Morfologia: ${athleteReport['morfologia'] ?? 'N/A'}'),
            Text('Rating Final: ${athleteReport['ratingFinal'] ?? 'N/A'}'),
            const SizedBox(height: 10),
            Text('Comentário: ${athleteReport['comentario'] ?? 'Nenhum comentário.'}'),
          ],
        ),
      ),
    );
  }
}