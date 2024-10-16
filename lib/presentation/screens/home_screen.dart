// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pi4_academico/presentation/screens/agenda_screen.dart';
import 'criaratleta_screen.dart';
import 'criarrelatorio_screen.dart';
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
    AgendaScreen(), // Substituir pela tela de "Agenda"
    CriarRelatorioScreen(),
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
        toolbarHeight: 100,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pedro Soares',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Icon(Icons.notifications, color: Colors.white),
                SizedBox(width: 10),
                Icon(Icons.account_circle, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Página Inicial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Criar Relatório',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt_1),
            label: 'Criar Atleta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Atletas',
          ),
        ],
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
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
                        Image.asset('assets/images/logo_red.png', height: 50),
                        Text('Red D.', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Devils Arena Stadium', style: TextStyle(color: Colors.grey)),
                        Text('19.45', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                        Text('9 May 2021', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset('assets/images/logo_green.png', height: 50),
                        Text('GreenTeam', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Match Countdown',
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
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
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
