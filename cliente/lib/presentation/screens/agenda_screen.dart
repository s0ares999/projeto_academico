import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pi4_academico/presentation/screens/detalhespartida_screen.dart';

class AgendaScreen extends StatefulWidget {
  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  List<dynamic> partidas = [];

  @override
  void initState() {
    super.initState();
    _carregarPartidas();
  }

  // Função para carregar as partidas da API
  Future<void> _carregarPartidas() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');
    final response = await http.get(Uri.parse('https://pi4-hdnd.onrender.com/partidas/atribuidas/$userId'));

    if (response.statusCode == 200) {
      setState(() {
        partidas = json.decode(response.body);
      });
    } else {
      throw Exception('Falha ao carregar partidas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: partidas.isEmpty
          ? Center(child: CircularProgressIndicator()) // Exibe um carregamento até que as partidas sejam carregadas
          : ListView.builder(
              itemCount: partidas.length,
              itemBuilder: (context, index) {
                var partida = partidas[index];
                var timeMandante = partida['timeMandante']['nome'];
                var timeVisitante = partida['timeVisitante']?['nome'] ?? 'Time Visitante não disponível';
                var data = partida['data'];
                var hora = partida['hora'];
                var local = partida['local'];

                return Container(
                  margin: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white, // Fundo branco
                    borderRadius: BorderRadius.circular(12), // Bordas arredondadas
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Cor da sombra
                        spreadRadius: 2, // Propaga a sombra
                        blurRadius: 5, // Intensidade da sombra
                        offset: Offset(0, 2), // Posição da sombra
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      '$timeMandante vs $timeVisitante',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8), // Espaçamento entre o título e os dados
                        Text('Data: $data'),
                        Text('Hora: $hora'),
                        Text('Local: $local'),
                      ],
                    ),
                    isThreeLine: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalhesPartidaScreen(partida: partida),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
