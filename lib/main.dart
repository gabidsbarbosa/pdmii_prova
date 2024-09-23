import 'package:flutter/material.dart';
import 'home_screen.dart'; // Importa a tela inicial

void main() {
  // Função principal que inicia o app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MaterialApp define o tema e a estrutura base do app
    return MaterialApp(
      title: 'Avaliação Notas',
      theme: ThemeData(
        primarySwatch: Colors.purple, // Define o tema da cor principal
      ),
      home: HomeScreen(), // Tela inicial é a HomeScreen
    );
  }
}