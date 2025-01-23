import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'home_screenconsultor.dart';
import 'forgotpassword_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Função para realizar o login e armazenar dados
  void _login() async {
    final String email = _usernameController.text;
    final String senha = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('https://pi4-hdnd.onrender.com/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'senha': senha,
        }),
      );

      print(
          "Request URL: ${Uri.parse('https://pi4-hdnd.onrender.com/auth/login')}");
      print("Response Status: ${response.statusCode}");
      print('Response Body: ${response.body}');

      // Verificando status e corpo da resposta
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String token = responseData['token'];
        final String userId =
            responseData['id'].toString(); // Converte para String
        final String userRole = responseData['role'];

        // Limpar dados de login anteriores
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('token');
        prefs.remove('userId');
        prefs.remove('userRole');

        // Armazenar o token e os dados do usuário
        prefs.setString('token', token);
        prefs.setString('userId', userId);
        prefs.setString('userRole', userRole);

        // Verificar e exibir os dados armazenados para depuração
        print('Token: $token');
        print('User Id: $userId');
        print('User Role: $userRole');

        // Navegar para a tela correspondente ao papel do usuário
        if (mounted) {
          try {
            if (userRole == 'Admin' || userRole == 'Scout') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else if (userRole == 'Consultor') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeScreenConsultor()),
              );
            }
          } catch (e) {
            print("Erro ao navegar: $e");
            if (mounted) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Erro ao navegar'),
                    content: Text('Erro ao navegar para a próxima tela: $e'),
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
        } else {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          String errorMessage = responseData['message'] ??
              'Nome de utilizador ou palavra-passe incorretos';

          // Exibe o erro caso o login falhe
          if (mounted)
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(errorMessage),
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
    } catch (error) {
      // Erro de conexão ou outro erro
      print("Erro de conexão ou outro erro: $error");
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Erro de conexão'),
              content: const Text('Não foi possível conectar ao servidor.'),
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
                const SizedBox(height: 10),
                // Logo Acadêmico
                Center(
                  child: Image.asset(
                    'assets/images/logoacademico.png',
                    width: 100, // Ajuste o tamanho conforme necessário
                    height: 100,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(218, 180, 178, 178),
                  ),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Nome de utilizador',
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(218, 180, 178, 178)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 237, 172, 43)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome de utilizador';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 46),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Palavra-passe',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(218, 180, 178, 178)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 237, 172, 43)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a palavra-passe';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.8, // 80% da largura da tela
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _login();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(218, 210, 210, 210),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Entrar',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      // Navega para a tela de recuperação de senha
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Esqueci-me da palavra-passe',
                      style: TextStyle(
                        color: Color.fromARGB(255, 237, 172, 43),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
