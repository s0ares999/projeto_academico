import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pi4_academico/presentation/screens/agenda_screen.dart';
import 'package:pi4_academico/presentation/screens/login_screen.dart';
import 'package:pi4_academico/presentation/screens/notificacoes_screen.dart';
import 'package:pi4_academico/theme_notifier.dart';
import 'consultaratleta_screen.dart';
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
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode:
                themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const HomeScreenConsultor(),
          );
        },
      ),
    );
  }
}

class HomeScreenConsultor extends StatefulWidget {
  const HomeScreenConsultor({super.key});

  @override
  _HomeScreenConsultorState createState() => _HomeScreenConsultorState();
}

class _HomeScreenConsultorState extends State<HomeScreenConsultor> {
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
      final response =
          await http.get(Uri.parse('http://192.168.1.118:3000/partidas'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['partidas'] != null && data['partidas'].isNotEmpty) {
          var lastMatch = (data['partidas'] as List).last;

          setState(() {
            nextMatch = lastMatch;
          });
        } else {
          setState(() {
            nextMatch = null;
          });
        }
      } else {
        throw Exception(
            'Erro ao carregar partida, código: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        nextMatch = null;
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
                    'Hiago Freitas',
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
                              builder: (context) => NotificacoesScreen(userId: 'userId'),
                            ),
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
        padding: const EdgeInsets.only(bottom: 0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 50,
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
                  SizedBox(width: 50), // Espaço reservado para o botão central
                  _buildNavItem(Icons.people, "Atletas", 2),
                  _buildNavItem(
                      Icons.logout, "Logout", 3), // Botão de logout adicionado
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: GestureDetector(
                onTap: () => _onItemTapped(0),
                child: Container(
                  padding: EdgeInsets.all(
                      4), // Reduzido o padding para dar mais espaço à imagem
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.grey, blurRadius: 4),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/logoacademico.png',
                    height:
                        42, // Ajustado para um valor menor, para evitar que o logo fique cortado
                    fit: BoxFit
                        .contain, // Garante que a imagem se ajuste ao tamanho do contêiner
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        if (label == "Logout") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        } else {
          _onItemTapped(index);
        }
      },
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
        ],
      ),
    );
  }
}
