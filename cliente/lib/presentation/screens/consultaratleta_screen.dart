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
  final List<String> filters = ["Ano", "Posição", "Clube", "Rating"];
  int selectedFilter = 0;
  int selectedRating = 3;
  String selectedPosition = '';

  @override
  void initState() {
    super.initState();
    _fetchAthletes(); // Busca os atletas ao inicializar a página
  }

Future<void> _fetchAthletes() async {
  const String url = 'http://192.168.8.135:4000/atletas'; // Adicione "http://" para uma URL válida
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
      _showErrorDialog('Erro ao carregar atletas. Código: ${response.statusCode}');
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
        athletes.sort((a, b) => (a['data_nascimento'] ?? '').compareTo(b['data_nascimento'] ?? ''));
      } else if (criterion == 'Clube') {
        athletes.sort((a, b) => (a['clube'] ?? '').compareTo(b['clube'] ?? ''));
      }
    });
  }

  Widget _buildPositionFilter() {
    final positions = [
      'Guarda Redes', 'Defesa Central', 'Lateral Esquerdo', 'Lateral Direito',
      'Médio Central', 'Médio Ofensivo', 'Médio Defensivo', 'Extremo Direito',
      'Extremo Esquerdo', 'Atacante', 'Universal'
    ];

    return Column(
      children: [
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: positions.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedPosition = selectedPosition == positions[index] ? '' : positions[index];
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedPosition == positions[index] ? Colors.orange : Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                positions[index],
                style: TextStyle(
                  color: selectedPosition == positions[index] ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

  @override
  Widget build(BuildContext context) {
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
                            color: selectedFilter == index ? Colors.orange : Colors.black,
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
              itemCount: athletes.length,
              itemBuilder: (context, index) {
                final athlete = athletes[index];
                return ListTile(
                  title: Text(athlete['nome']),
                  subtitle: Text('Clube: ${athlete['clube']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${athlete['rating']}'),
                      const Icon(Icons.star, color: Colors.orange),
                    ],
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
