// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:pi4_academico/presentation/screens/agenda_screen.dart';
import 'package:pi4_academico/presentation/screens/login_screen.dart';
import 'package:pi4_academico/presentation/screens/notificacoes_screen.dart';
import 'criaratleta_screen.dart';
import 'consultaratleta_screen.dart';
import 'package:provider/provider.dart';
import '/theme_notifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomePageContent(),
    AgendaScreen(),
    CriarAtletaScreen(),
    ConsultarAtletaScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Seção do topo arredondada
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
                        icon: Icon(Icons.notifications, color: Colors.white, size: 20),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NotificacoesScreen()),
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
                          Provider.of<ThemeNotifier>(context).isDarkMode
                              ? Icons.brightness_3
                              : Icons.brightness_7,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          Provider.of<ThemeNotifier>(context, listen: false)
                              .toggleTheme();
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
                  blurRadius: 6),
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
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: _selectedIndex == index ? Colors.orange : Colors.black,
              size: 20),
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
      onTap: () {
        // Navegação para a página inicial ao clicar no logotipo central
        setState(() {
          _selectedIndex = 0;
        });
      },
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
  const HomePageContent({super.key});

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Image.asset('assets/images/logo_red.png', height: 40),
                        Text('Red D.',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.stadium, color: Colors.grey, size: 18),
                        Text('Estádio da Luz',
                            style: TextStyle(color: Colors.grey, fontSize: 10)),
                        Text('19.45',
                            style: TextStyle(
                                color: Colors.orange, fontSize: 26, fontWeight: FontWeight.bold)),
                        Text('28 Março 2025',
                            style: TextStyle(color: Colors.grey, fontSize: 10)),
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset('assets/images/logo_green.png', height: 40),
                        Text('Victory G.',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Próximo jogo',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCountdownUnit('02', 'Days'),
                    _buildCountdownUnit('08', 'Hrs'),
                    _buildCountdownUnit('47', 'Mins'),
                    _buildCountdownUnit('01', 'Secs'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Coluna com os botões um em cima do outro
          Column(
            children: [
              _buildSmallButton(context, 'AGENDA', AgendaScreen()),
              SizedBox(height: 8),
              _buildSmallButton(context, 'ATLETAS', ConsultarAtletaScreen()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownUnit(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildSmallButton(BuildContext context, String text, Widget targetScreen) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: Size(200, 45),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}
