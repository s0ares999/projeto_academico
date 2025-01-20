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
    _fetchAthletes(); // Busca os atletas
    _fetchReports(); // Busca os relatórios
  }

  Future<void> _fetchAthletes() async {
    const String url = 'http://192.168.1.118:3000/atletas';
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
        // Exibir uma mensagem de erro caso a resposta não seja 200
        _showErrorDialog(
            'Erro ao carregar atletas. Código: ${response.statusCode}');
      }
    } catch (e) {
      // Tratar erros de conexão ou outros problemas
      _showErrorDialog('Erro de conexão: ${e.toString()}');
    }
  }

  Future<void> _fetchReports() async {
    const String url = 'http://192.168.1.118:3000/relatorios';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Decodificar a resposta do servidor
        final List<dynamic> decodedData = json.decode(response.body);

        // Atualizar o estado com os relatórios
        setState(() {
          reports = List<Map<String, dynamic>>.from(decodedData);
        });
      } else {
        // Exibir uma mensagem de erro caso a resposta não seja 200
        _showErrorDialog(
            'Erro ao carregar relatórios. Código: ${response.statusCode}');
      }
    } catch (e) {
      // Tratar erros de conexão ou outros problemas
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

  void _sortAthletes(String criterion) {
    setState(() {
      if (criterion == 'Ano') {
        athletes.sort((a, b) =>
            (a['data_nascimento'] ?? '').compareTo(b['data_nascimento'] ?? ''));
      } else if (criterion == 'Clube') {
        athletes.sort((a, b) => (a['clube'] ?? '').compareTo(b['clube'] ?? ''));
      }
    });
  }

  List<Map<String, dynamic>> _filterByRating() {
    return athletes.where((athlete) {
      // Filtra os atletas conforme o rating selecionado
      return athlete['rating'] == selectedRating;
    }).toList();
  }

  Widget _buildPositionFilter() {
    final positions = [
      'Guarda-Redes',
      'Defesa Central',
      'Defesa Esquerda',
      'Defesa Direita',
      'Médio',
      'Atacante'
    ];

    return Column(
      children: [
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio:
                1.5, // Ajuste a proporção largura/altura dos cards
          ),
          itemCount: positions.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedPosition = selectedPosition == positions[index]
                      ? ''
                      : positions[index];
                });
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.all(8), // Adiciona mais espaço interno
                backgroundColor: selectedPosition == positions[index]
                    ? Colors.orange
                    : Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: FittedBox(
                fit: BoxFit
                    .scaleDown, // Ajusta automaticamente o texto ao espaço
                child: Text(
                  positions[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selectedPosition == positions[index]
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // Pode ajustar o tamanho da fonte
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text(
            'Aplicar',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingFilter() {
    return Column(
      children: List.generate(5, (index) {
        return RadioListTile<int>(
          title: Text('${index + 1} Estrela'),
          value: index + 1,
          groupValue: selectedRating,
          onChanged: (int? value) {
            setState(() {
              selectedRating = value!;
            });
            Navigator.of(context).pop();
          },
        );
      }),
    );
  }

  // Função para obter o ratingFinalSelecionado de um atleta
  int _getAthleteRating(String athleteId) {
    // Encontrar o relatório correspondente ao atleta
    final report = reports.firstWhere(
      (report) => report['atleta_id'] == athleteId,
      orElse: () => {},
    );
    // Retornar o ratingFinalSelecionado do relatório, ou 0 caso não exista
    return report.isNotEmpty ? report['ratingFinalSelecionado'] ?? 0 : 0;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredAthletes = athletes;

    // Aplica o filtro de rating se o filtro de rating estiver ativo
    if (selectedRating != 3) {
      filteredAthletes = _filterByRating();
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
                    if (filters[index] == 'Ano' || filters[index] == 'Clube') {
                      _sortAthletes(filters[index]);
                    } else if (filters[index] == 'Posição') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Filtrar por Posição'),
                            content: _buildPositionFilter(),
                          );
                        },
                      );
                    } else if (filters[index] == 'Rating') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Filtrar por Rating'),
                            content: _buildRatingFilter(),
                          );
                        },
                      );
                    }
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
                      vertical: 6.0,
                      horizontal:
                          16.0), // Margem para dar espaço entre os itens
                  decoration: BoxDecoration(
                    color: Colors.white, // Cor de fundo do item
                    borderRadius:
                        BorderRadius.circular(10), // Borda arredondada
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey
                            .withOpacity(0.3), // Cor e opacidade da sombra
                        spreadRadius: 2, // Quanto a sombra se espalha
                        blurRadius: 5, // Intensidade do desfoque
                        offset: Offset(0, 2), // Posição da sombra
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
