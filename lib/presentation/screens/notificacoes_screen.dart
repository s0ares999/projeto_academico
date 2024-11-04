// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class NotificacoesScreen extends StatelessWidget {
  const NotificacoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Notificações', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              // Apagar todas as notificações
            },
            child: Text(
              'Apagar tudo',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          NotificationCard(
            title: 'Relatório submetido',
            timeAgo: 'Há 10 minutos',
            description: 'Inês Fernandes submeteu um novo relatório',
            actions: [
              ActionButton(text: 'Ver', color: Colors.orange, onPressed: () {}),
              ActionButton(text: 'Aprovar', color: Colors.green, onPressed: () {}),
            ],
            backgroundColor: Colors.orange.shade50,
          ),
          NotificationCard(
            title: 'Tem um novo jogo',
            timeAgo: 'Há 2 dias',
            description: '',
            actions: [
              ActionButton(text: 'Ver', color: Colors.orange, onPressed: () {}),
            ],
          ),
          NotificationCard(
            title: 'Tem validações pendentes',
            timeAgo: 'Semana passada',
            description: '',
            actions: [
              ActionButton(text: 'Ver', color: Colors.orange, onPressed: () {}),
            ],
          ),
          NotificationCard(
            title: 'Pedido de alteração de palavra-passe',
            timeAgo: 'Semana passada',
            description: 'Utilizador Maria pediu para alterar a palavra-passe',
            actions: [
              ActionButton(text: 'Aprovar', color: Colors.green, onPressed: () {}),
              ActionButton(text: 'Recusar', color: Colors.red, onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String timeAgo;
  final String description;
  final List<Widget> actions;
  final Color backgroundColor;

  const NotificationCard({
    super.key,
    required this.title,
    required this.timeAgo,
    required this.description,
    required this.actions,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  timeAgo,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            if (description.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ],
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: actions
                  .map((action) => Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: action,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
