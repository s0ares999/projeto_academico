import 'package:flutter/material.dart';

class ConsultarAtletaScreen extends StatelessWidget {
  const ConsultarAtletaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar Atletas'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Página para consultar atletas',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
