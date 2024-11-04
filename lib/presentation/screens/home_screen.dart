// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pi4_academico/presentation/screens/agenda_screen.dart';
import 'package:pi4_academico/presentation/screens/notificacoes_screen.dart';
import 'criaratleta_screen.dart';
import 'consultaratleta_screen.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 80,
        title: Row(
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
              children: [
                IconButton(
                  icon:
                      Icon(Icons.notifications, color: Colors.white, size: 20),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificacoesScreen()),
                    );
                  },
                ),
                SizedBox(width: 8),
                Icon(Icons.account_circle, color: Colors.white, size: 20),
              ],
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0),
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
    return Container(
      margin: EdgeInsets.only(bottom: 1), // Levanta o logo por 2 pixels
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 4),
        ],
      ),
      child: Container(
        // Usando um Container para exibir a imagem
        child: Image.asset(
          'assets/images/logoacademico.png',
          height: 50, // Ajuste o tamanho da logo conforme necessário
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 4,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
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
                        Text('Devils Arena Stadium',
                            style: TextStyle(color: Colors.grey, fontSize: 10)),
                        Text('19.45',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        Text('9 May 2021',
                            style: TextStyle(color: Colors.grey, fontSize: 10)),
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset('assets/images/logo_green.png', height: 40),
                        Text('GreenTeam',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Match Countdown',
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
}
