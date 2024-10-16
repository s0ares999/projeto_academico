import 'package:flutter/material.dart';

class CriarRelatorioScreen extends StatelessWidget {
  const CriarRelatorioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Relatório'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Página para criar relatório',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
