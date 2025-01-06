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
  Map<String, dynamic>? nextMatch;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _fetchNextMatch();
  }

 Future<void> _fetchNextMatch() async {
  try {
    final response = await http.get(Uri.parse('http://192.168.1.118:4100/partidas'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Resposta da API: $data'); // Adicione este print para depuração

      if (data['partidas'] != null && data['partidas'].isNotEmpty) {
        // Pega a última partida criada, sem filtrar apenas as futuras
        var lastMatch = (data['partidas'] as List).last;

        setState(() {
          nextMatch = lastMatch; // Pega a última partida
        });
      } else {
        setState(() {
          nextMatch = null; // Nenhuma partida encontrada
        });
      }
    } else {
      throw Exception('Erro ao carregar partida, código: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro ao buscar partida: $e'); // Exibe erro no console
    setState(() {
      nextMatch = null; // Se ocorrer erro na requisição
    });
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
                    'Pedro Soares',
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
                        icon: Icon(Icons.notifications,
                            color: Colors.white, size: 20),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificacoesScreen()),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.logout, color: Colors.white, size: 20),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
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
  final Map<String, dynamic>? nextMatch;

  const HomePageContent({super.key, this.nextMatch});

  @override
  Widget build(BuildContext context) {
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
            child: nextMatch != null
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                nextMatch!['timeMandante'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                nextMatch!['hora'],
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                DateTime.parse(nextMatch!['data'])
                                    .toLocal()
                                    .toString()
                                    .substring(0, 10),
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                nextMatch!['timeVisitante'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                : Text(
                    "Nenhum jogo encontrado.",
                    style: TextStyle(color: Colors.grey),
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
          )
        ],
      ),
    );
  }
}
