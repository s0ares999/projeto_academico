import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pi4_academico/presentation/screens/agendaconsultor_screen.dart';
import 'package:pi4_academico/presentation/screens/login_screen.dart';
import 'package:pi4_academico/presentation/screens/notificacoes_screen.dart';
import 'package:pi4_academico/theme_notifier.dart';
import 'consultaratleta_screen.dart';
import 'package:provider/provider.dart';
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
  String _userName = ''; // Variável para armazenar o nome do usuário

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Chama a função para buscar o nome do usuário
  }

  // Função para buscar o nome do usuário
  Future<void> _fetchUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null) {
      try {
        final response = await http.get(
          Uri.parse('https://pi4-hdnd.onrender.com/utilizadores/$userId'),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          setState(() {
            _userName = data['nome'] ??
                'Nome não encontrado'; // Supondo que a resposta contenha o campo 'nome'
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _screens.addAll([
      HomePageContent(),
      AgendaConsultorScreen(),
      ConsultarAtletaScreen(), // Removido CriarAtletaScreen
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
                    _userName.isEmpty
                        ? 'Carregando...'
                        : _userName, // Exibe o nome ou 'Carregando...'
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
                                builder: (context) =>
                                    NotificacoesScreen(userId: 'userId')),
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
              _buildCentralLogo(), // Logo central
              _buildNavItem(Icons.people, "Atletas", 2),
              _buildNavItem(Icons.logout, "Logout", 3), // Botão de logout
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        if (label == "Logout") {
          // Lógica para logout
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
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

  Widget _buildCentralLogo() {
    return GestureDetector(
      onTap: () => _onItemTapped(0), // Volta para a tela inicial ao clicar
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
          'assets/images/logoacademico.png', // Caminho da imagem do logo
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
          SizedBox(height: 65),
          // Mensagem de boas-vindas
          Text(
            "Bem-vindo ao Viriatus Scouting",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          // Subtítulo adicional
          Text(
            "Sua plataforma de scouting de futebol",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 16),
          // Logo
          SizedBox(height: 24),
        ],
      ),
    );
  }
}