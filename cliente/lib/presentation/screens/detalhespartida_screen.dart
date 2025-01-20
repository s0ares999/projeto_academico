import 'package:flutter/material.dart';

class DetalhesPartidaScreen extends StatelessWidget {
  final Map<String, dynamic> partida;

  DetalhesPartidaScreen({required this.partida});

  @override
  Widget build(BuildContext context) {
    var timeMandante = partida['timeMandante']['nome'];
    var timeVisitante =
        partida['timeVisitante']?['nome'] ?? 'Time Visitante não disponível';
    var data = partida['data'];
    var hora = partida['hora'];
    var local = partida['local'];
    var jogadores = partida['jogadores'] ?? []; // Lista de jogadores
    var scouts = partida['scouts'] ?? []; // Lista de scouts

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Detalhes da Partida'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Informações básicas da partida
              Text(
                '$timeMandante vs $timeVisitante',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Data: $data'),
              Text('Hora: $hora'),
              Text('Local: $local'),
              SizedBox(height: 16),
              Divider(),

              // Seção de jogadores
              Text(
                'Jogadores',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              jogadores.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: jogadores.length,
                      itemBuilder: (context, index) {
                        var jogador = jogadores[index];
                        return ListTile(
                          title: Text(jogador['nome']),
                          subtitle: Text('Posição: ${jogador['posicao']}'),
                        );
                      },
                    )
                  : Text('Nenhum jogador cadastrado para esta partida.'),
              SizedBox(height: 16),
              Divider(),

              // Seção de scouts
              Text(
                'Scouts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              scouts.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: scouts.length,
                      itemBuilder: (context, index) {
                        var scout = scouts[index];
                        return ListTile(
                          title: Text(scout['nome']), // Nome do scout
                        );
                      },
                    )
                  : Text('Nenhum scout atribuído a esta partida.'),
            ],
          ),
        ),
      ),
    );
  }
}
