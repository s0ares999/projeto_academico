import 'package:flutter/material.dart';
import 'package:pi4_academico/presentation/screens/criarrelatorio_screen.dart';

class CriarAtletaScreen extends StatelessWidget {
  const CriarAtletaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        title: const Text('CRIAR ATLETA'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo para Nome do Atleta
              buildTextField('Nome do Atleta', '|'),
              const SizedBox(height: 30),

              // Formulário de criação de atleta
              buildTextField('Data de nascimento', '|'),
              const SizedBox(height: 30),
              buildTextField('Clube', '|'),
              const SizedBox(height: 30),
              buildTextField('Posição', '|'),
              const SizedBox(height: 30),
              buildTextField('Nacionalidade', '|'),
              const SizedBox(height: 30),
              buildTextField(
                  'Encarregado de educação/agente', '|'),
              const SizedBox(height: 30),

              // Botão de Criar Relatório
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48, vertical: 16),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CriarRelatorioScreen()),
                    );
                  },
                  child: const Text(
                    'Criar Relatório',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para construir os campos de texto
  Widget buildTextField(String label, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: placeholder,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
