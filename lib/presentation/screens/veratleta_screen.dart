import 'package:flutter/material.dart';
import 'package:pi4_academico/presentation/screens/criarrelatorio_screen.dart';

class VeratletaScreen extends StatelessWidget {
  const VeratletaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        title: const Text('Atleta', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Formulário de criação de atleta
              buildTextField('Nome completo', 'Inês Fernandes'),
              const SizedBox(height: 30),
              buildTextField('Data e ano de nascimento', '01/08/2003'),
              const SizedBox(height: 30),
              buildTextField('Clube', 'Benfica'),
              const SizedBox(height: 30),
              buildTextField('Posição', 'Avançado'),
              const SizedBox(height: 30),
              buildTextField('Nacionalidade', 'Portuguesa'),
              const SizedBox(height: 30),
              buildTextField('Encarregado de educação/agente', 'Sra.'),
              const SizedBox(height: 30),

              // Botão para Criar relatorio
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
                          builder: (context) => const CriarRelatorioScreen ()),
                    );
                  },
                  child: const Text(
                    'Criar relatório',
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

// Função para construir os campos de texto estilizados
  Widget buildTextField(String label, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: SizedBox(
            width: 300, // Define uma largura menor para o campo
            child: TextField(
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0), // Texto placeholder cinza claro
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 139, 139, 139), // Cor do contorno cinza claro
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 0, 0, 0), // Contorno cinza claro quando inativo
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 0, 0, 0), // Contorno preto ao focar
                    width: 1.5,
                  ),
                ),
              ),
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0), // Texto do campo em cinza claro
              ),
            ),
          ),
        ),
      ],
    );
  }
}
