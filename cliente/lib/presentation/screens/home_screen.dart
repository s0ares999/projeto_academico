import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pi4_academico/presentation/screens/agenda_screen.dart';
import 'package:pi4_academico/presentation/screens/login_screen.dart';
import 'package:pi4_academico/presentation/screens/notificacoes_screen.dart';
import 'package:pi4_academico/theme_notifier.dart';
import 'criaratleta_screen.dart';
import 'consultaratleta_screen.dart';
import 'criarrelatorio_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(), // Tema claro
            darkTheme: ThemeData.dark(), // Tema escuro
            themeMode: themeNotifier.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light, // Altera o tema dinamicamente
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _userName = '';  // Variável para armazenar o nome do usuário
  List<dynamic>? nextMatch; // Lista para armazenar todas as partidas

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _fetchUserName();  // Chama a função para buscar o nome do usuário
    _fetchMatches(); // Chama a função para carregar as partidas
  }

  // Função para buscar o nome do usuário
  Future<void> _fetchUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null) {
      try {
        final response = await http.get(
          Uri.parse('http://192.168.1.118:3000/utilizadores/$userId'),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          setState(() {
            _userName = data['nome'] ?? 'Nome não encontrado'; // Supondo que a resposta contenha o campo 'nome'
          });
        } else {
          setState(() {
            _userName = 'Nome não disponível';
          });
        }
      } catch (e) {
        setState(() {
          _userName = 'Erro ao buscar nome';
        });
        print('Erro ao buscar nome do usuário: $e');
      }
    }
  }

  Future<void> _fetchMatches() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.8.135:3000/partidas'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Resposta da API: $data');

        if (data != []) {
          setState(() {
            nextMatch = data.map((match) {
              print(
                  'Partida: ${match['timeMandanteId']} - ${match['timeVisitanteId']}');
              return {
                'timeMandanteId': match['timeMandante']['id'],
                'timeVisitanteId': match['timeVisitante']['id'],
                'hora': match['hora'],
                'data': DateTime.parse(match['data']), // Verificar o formato
                'jogadoresIds': List<int>.from(
                    match['jogadores'].map((jogador) => jogador['id'])),
                'scoutsIds':
                    List<int>.from(match['scouts'].map((scout) => scout['id'])),
                'local': match['local'],
              };
            }).toList();
          });
        } else {
          setState(() {
            nextMatch = null;
          });
        }
      } else {
        throw Exception(
            'Erro ao carregar partidas, código: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar partidas: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _screens.addAll([
      HomePageContent(nextMatch: nextMatch),
      AgendaScreen(),
      CriarAtletaScreen(),
      ConsultarAtletaScreen(),
    ]);

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _userName.isEmpty ? 'Carregando...' : _userName,  // Exibe o nome ou 'Carregando...'
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications, color: Colors.white, size: 20),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NotificacoesScreen(userId: 'userId')),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.logout, color: Colors.white, size: 20),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          context.watch<ThemeNotifier>().isDarkMode
                              ? Icons.brightness_7
                              : Icons.brightness_4,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          // Alterna entre os modos de tema
                          context.read<ThemeNotifier>().toggleTheme();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, "Início", 0),
              _buildNavItem(Icons.calendar_today, "Agenda", 1),
              _buildCentralLogo(),
              _buildNavItem(Icons.person_add_alt_1, "Criar", 2),
              _buildNavItem(Icons.people, "Atletas", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: _selectedIndex == index ? Colors.orange : Colors.black,
            size: 20,
          ),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index ? Colors.orange : Colors.black,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCentralLogo() {
    return GestureDetector(
      onTap: () => _onItemTapped(0),
      child: Container(
        margin: EdgeInsets.only(bottom: 1),
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 4),
          ],
        ),
        child: Image.asset(
          'assets/images/logoacademico.png',
          height: 50,
        ),
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  final List<dynamic>? nextMatch;

  const HomePageContent({super.key, this.nextMatch});

  @override
  Widget build(BuildContext context) {
    print('AAAAAAAAAAAAAAAAAAAAAAAA: $nextMatch');

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  spreadRadius: 4,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: nextMatch != null && nextMatch!.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: nextMatch!.length,
                    itemBuilder: (context, index) {
                      var match = nextMatch![index];
                      // Verificar os dados recebidos
                      print('Partida: $match');

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Verificando se os dados existem antes de acessá-los
                            Column(
                              children: [
                                Text(
                                  'Mandante: ${match['timeMandanteId'] ?? "Desconhecido"}', // Previne erro caso esteja nulo
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(
                                  'Jogadores: ${match['jogadoresIds']?.length ?? 0}', // Verifica se 'jogadoresIds' não é null
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  match['hora'] ??
                                      'Hora não disponível', // Verifica se a hora existe
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  match['data'] != null
                                      ? DateFormat('yyyy-MM-dd')
                                          .format(match['data']!)
                                      : 'Data inválida', // Se a data for null
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10),
                                ),
                                Text(
                                  match['local'] ??
                                      'Local não especificado', // Verifica se o local existe
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Visitante: ${match['timeVisitanteId'] ?? "Desconhecido"}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(
                                  'Scouts: ${match['scoutsIds']?.length ?? 0}',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      "Nenhuma partida encontrada.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
          ),


          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CriarRelatorioScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // Cor de fundo preta
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14), // Bordas arredondadas
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              "Criar Relatório",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Cor do texto branca
              ),
            ),
          ),
        ],
      ),
    );
  }
}