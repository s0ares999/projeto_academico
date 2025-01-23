import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _emailValidated = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Função para buscar todos os usuários e verificar se o email existe
  Future<void> _validateEmail() async {
    final String email = _emailController.text;

    if (email.isNotEmpty && email.contains('@')) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Faz a requisição ao backend para buscar todos os usuários
        final response = await http.get(
          Uri.parse('https://pi4-hdnd.onrender.com/utilizadores'),
        );

        if (response.statusCode == 200) {
          final List<dynamic> users = json.decode(response.body);

          // Verifica se o email existe na lista de usuários
          final user = users.firstWhere(
            (user) => user['email'] == email,
            orElse: () => null,
          );

          if (user != null) {
            setState(() {
              _emailValidated = true;
            });
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Email não encontrado'),
                  content: const Text('O email fornecido não está registrado.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          throw Exception('Erro ao buscar usuários');
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Erro'),
              content: Text('Ocorreu um erro ao verificar o email: $e'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Email inválido'),
            content: const Text('Por favor, insira um email válido.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  // Função para enviar a nova senha ao backend
Future<void> _resetPassword() async {
  final String newPassword = _newPasswordController.text.trim();
  final String confirmPassword = _confirmPasswordController.text.trim();

  // Verifica se os campos de senha não estão vazios
  if (newPassword.isNotEmpty && confirmPassword.isNotEmpty) {
    // Verifica se as senhas são iguais
    if (newPassword == confirmPassword) {
      setState(() {
        _isLoading = true; // Ativa o indicador de carregamento
      });

      try {
        // Recupera o userId do SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('userId');

        if (userId == null) {
          throw Exception('Usuário não autenticado');
        }

        // Faz a requisição ao backend para buscar todos os usuários
        final response = await http.get(
          Uri.parse('https://pi4-hdnd.onrender.com/utilizadores'),
        );

        // Verifica se a requisição foi bem-sucedida
        if (response.statusCode == 200) {
          final List<dynamic> users = json.decode(response.body);

          // Encontra o usuário com o email fornecido
          final user = users.firstWhere(
            (user) => user['email'] == _emailController.text.trim(),
            orElse: () => null,
          );

          if (user != null) {
            // Atualiza a senha do usuário
            final updateResponse = await http.put(
              Uri.parse('https://pi4-hdnd.onrender.com/utilizadores/$userId'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({
                'senha': newPassword,
                }),
              );

              if (updateResponse.statusCode == 200) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Senha alterada com sucesso'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pop(
                                context); // Volta para a tela anterior
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                throw Exception('Erro ao alterar a senha');
              }
            } else {
              throw Exception('Usuário não encontrado');
            }
          } else {
            throw Exception('Erro ao buscar usuários');
          }
        } catch (e) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Erro'),
                content: Text('Ocorreu um erro ao alterar a senha: $e'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('As senhas não coincidem'),
              content: const Text(
                  'Por favor, insira senhas iguais nos dois campos.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Campos vazios'),
            content:
                const Text('Por favor, preencha ambos os campos de senha.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 130),
                const Text(
                  'Esqueci-me da',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(218, 180, 178, 178),
                  ),
                ),
                const Text(
                  'palavra-passe',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(218, 180, 178, 178),
                  ),
                ),
                const SizedBox(height: 70),
                if (!_emailValidated)
                  Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(218, 180, 178, 178)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 237, 172, 43)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.contains('@')) {
                            return 'Por favor, insira um email válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    _validateEmail();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(218, 210, 210, 210),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 20),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text('VALIDAR EMAIL',
                                  style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                if (_emailValidated)
                  Column(
                    children: [
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: !_isNewPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Nova palavra-passe',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isNewPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isNewPasswordVisible = !_isNewPasswordVisible;
                              });
                            },
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(218, 180, 178, 178)),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 237, 172, 43)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a nova palavra-passe';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Confirmar palavra-passe',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(218, 180, 178, 178)),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 237, 172, 43)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, confirme a palavra-passe';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    _resetPassword();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(218, 210, 210, 210),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 20),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text('ALTERAR SENHA',
                                  style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
