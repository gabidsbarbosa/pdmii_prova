import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Biblioteca HTTP
import 'dart:convert';

class NotasScreen extends StatefulWidget {
  final String token; // Recebe o token da tela de login

  NotasScreen({required this.token});

  @override
  _NotasScreenState createState() => _NotasScreenState();
}

class _NotasScreenState extends State<NotasScreen> {
  List alunos = []; // Lista de alunos
  List filteredAlunos = []; // Lista de alunos filtrados com base nas notas

  // Função para buscar as notas do endpoint
  Future<void> _fetchNotas() async {
    final response = await http.get(
      Uri.parse('https://demo4150164.mockable.io/notasAlunos'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        alunos = data['alunos']; // Armazena a lista de alunos
        filteredAlunos = alunos; // Inicialmente, todos os alunos são mostrados
      });
    } else {
      // Mostra erro na requisição
      print('Erro ao buscar notas');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNotas(); // Busca as notas quando a tela é carregada
  }

  // Função para filtrar os alunos por nota
  void _filterNotas(int min, int max) {
    setState(() {
      filteredAlunos = alunos
          .where((aluno) => aluno['nota'] >= min && aluno['nota'] < max)
          .toList(); // Filtra os alunos de acordo com as notas
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notas dos Alunos')), // Título da tela
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Botão para filtrar alunos com nota < 60
              ElevatedButton(
                onPressed: () => _filterNotas(0, 60),
                child: Text('Nota < 60'),
              ),
              // Botão para filtrar alunos com nota >= 60 e < 100
              ElevatedButton(
                onPressed: () => _filterNotas(60, 100),
                child: Text('Nota >= 60 e < 100'),
              ),
              // Botão para filtrar alunos com nota 100
              ElevatedButton(
                onPressed: () => _filterNotas(100, 101),
                child: Text('Nota = 100'),
              ),
            ],
          ),
          // Lista de alunos filtrados
          Expanded(
            child: ListView.builder(
              itemCount: filteredAlunos.length,
              itemBuilder: (context, index) {
                final aluno = filteredAlunos[index];
                Color backgroundColor;
                // Define a cor de fundo com base na nota
                if (aluno['nota'] == 100) {
                  backgroundColor = Colors.green; // Verde para nota 100
                } else if (aluno['nota'] >= 60) {
                  backgroundColor = Colors.blue; // Azul para nota >= 60
                } else {
                  backgroundColor = Colors.yellow; // Amarelo para nota < 60
                }
                // Item da lista com o nome e nota do aluno
                return Container(
                  color: backgroundColor, // Cor de fundo do item
                  child: ListTile(
                    title: Text(aluno['nome']), // Nome do aluno
                    subtitle: Text('Nota: ${aluno['nota']}'), // Nota do aluno
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
