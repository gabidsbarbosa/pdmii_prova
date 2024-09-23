import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Biblioteca para fazer requisições HTTP
import 'dart:convert';
import 'notas_screen.dart'; // Importa a tela de notas

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para capturar o texto dos campos de nome e senha
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String token = ''; // Armazena o token recebido após login

  Future<void> _login() async {
    // Faz a requisição POST para o endpoint de login
    final response = await http.post(
      Uri.parse('https://demo4150164.mockable.io/login'),
      body: json.encode({
        'name': _nameController.text, // Nome inserido
        'password': _passwordController.text, // Senha inserida
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        token = data['token']; // Armazena o token recebido
      });
      // Navega para a tela de notas, passando o token
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotasScreen(token: token)),
      );
    } else {
      // Mostra erro no login
      print('Erro no login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')), // Título da tela de login
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de texto para inserir o nome
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            // Campo de texto para inserir a senha (oculto)
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20), // Espaçamento
            ElevatedButton(
              // Botão que realiza o login
              onPressed: _login,
              child: Text('Login'),
            ),
            // Mostra o token recebido, se existir
            if (token.isNotEmpty) Text('Token: $token'),
          ],
        ),
      ),
    );
  }
}
