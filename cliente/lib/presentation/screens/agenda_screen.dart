import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    final response = await http.get(Uri.parse('http://192.168.0.27:3000/partidas'));

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

                return Card(
                  margin: EdgeInsets.all(12),
                  child: ListTile(
                    title: Text('$timeMandante vs $timeVisitante'),
                    subtitle: Text('Data: $data, Hora: $hora  Local: $local'),
                    isThreeLine: true,
                    onTap: () {
                      // Ação ao clicar em uma partida (pode ser detalhamento ou outra ação)
                    },
                  ),
                );
              },
            ),
    );
  }
}
