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
        iconTheme:
            const IconThemeData(color: Colors.black), // Para o botão de voltar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo para Nome do Atleta
              buildTextField('Nome do Atleta', 'Digite o nome do atleta'),
              const SizedBox(height: 16),

              // Campo para Ano de Nascimento
              buildTextField('Ano de Nascimento', 'Digite o ano de nascimento'),
              const SizedBox(height: 24),

              // Formulário de criação de atleta
              buildTextField('Data de nascimento', 'Digite a data de nascimento'),
              const SizedBox(height: 16),
              buildTextField('Clube', 'Digite o Clube'),
              const SizedBox(height: 16),
              buildTextField('Posição', 'Digite a Posição'),
              const SizedBox(height: 16),
              buildTextField('Nacionalidade', 'Digite a Nacionalidade'),
              const SizedBox(height: 16),
              buildTextField(
                  'Encarregado de educação/agente', 'Digite o encarregado de Educação'),
              const SizedBox(height: 32),

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
                          builder: (context) => CriarRelatorioScreen()),
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
