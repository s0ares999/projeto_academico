import 'package:flutter/material.dart';

class ConsultarAtletaScreen extends StatefulWidget {
  const ConsultarAtletaScreen({super.key});

  @override
  _ConsultarAtletaScreenState createState() => _ConsultarAtletaScreenState();
}

class _ConsultarAtletaScreenState extends State<ConsultarAtletaScreen> {
  final List<Map<String, dynamic>> athletes = [
    {'name': 'Pedro Soares', 'year': 2002, 'rating': 4, 'club': 'Clube A', 'position': 'Atacante'},
    {'name': 'Hiago Freitas', 'year': 1999, 'rating': 3, 'club': 'Clube B', 'position': 'Meio-campo'},
    {'name': 'Inês Fernandes', 'year': 2003, 'rating': 5, 'club': 'Clube A', 'position': 'Defensora'},
    {'name': 'Maria Bernardo', 'year': 2003, 'rating': 2, 'club': 'Clube C', 'position': 'Atacante'},
    {'name': 'Margarida Santos', 'year': 2003, 'rating': 3, 'club': 'Clube B', 'position': 'Meio-campo'},
  ];

  final List<String> filters = ["Ano", "Posição", "Clube", "Rating"];
  int selectedFilter = 0;
  int selectedRating = 3; // Valor padrão para evitar null
  String selectedPosition = ''; // Para armazenar a posição selecionada

  void _sortAthletes(String criterion) {
    setState(() {
      if (criterion == 'Ano') {
        athletes.sort((a, b) {
          int yearA = a['year'] ?? 0;
          int yearB = b['year'] ?? 0;
          return yearA.compareTo(yearB);
        });
      } else if (criterion == 'Clube') {
        athletes.sort((a, b) {
          String clubA = a['club'] ?? '';
          String clubB = b['club'] ?? '';
          return clubA.compareTo(clubB);
        });
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
        // Lista de botões de posição
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,  // Três colunas para os botões
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: positions.length,
          shrinkWrap: true, // Impede que a lista ocupe espaço excessivo
          physics: const NeverScrollableScrollPhysics(), // Impede rolagem dentro do grid
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
                padding: const EdgeInsets.all(12.0),
              ),
              child: Text(
                positions[index],
                style: TextStyle(
                  color: selectedPosition == positions[index] ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12, // Ajuste para o tamanho da fonte
                ),
              ),
            );
          },
        ),
        // Botão "Aplicar"
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fecha o pop-up
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange, // Cor laranja para o botão
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12.0),
          ),
          child: const Text(
            'Aplicar',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  // Pop-up de Rating
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
            Navigator.of(context).pop(); // Fecha o pop-up após selecionar
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
          // Barra de pesquisa substituindo o título
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
          // Filtros horizontais com ordenação por Ano, Posição e Clube
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
                    if (filters[index] == "Ano" || filters[index] == "Clube") {
                      _sortAthletes(filters[index]);
                    } else if (filters[index] == "Posição") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Filtrar por Posição',
                              style: TextStyle(fontSize: 14), // Reduzindo o tamanho da fonte
                            ),
                            content: SizedBox(
                              height: 319, // Ajustando a altura para não sobrecarregar
                              child: _buildPositionFilter(),
                            ),
                            actions: const [],
                          );
                        },
                      );
                    } else if (filters[index] == "Rating") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Filtrar por Rating'),
                            content: _buildRatingFilter(),
                            actions: const [],
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
          // Lista de atletas com rating
          Expanded(
            child: ListView.builder(
              itemCount: athletes.length,
              itemBuilder: (context, index) {
                final athlete = athletes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              athlete['name'],
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text('Ano: ${athlete['year']}'),
                            Text('Clube: ${athlete['club']}'),
                            Text('Posição: ${athlete['position']}'),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${athlete['rating']}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 18,
                            ),
                          ],
                        ),
                      ],
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
