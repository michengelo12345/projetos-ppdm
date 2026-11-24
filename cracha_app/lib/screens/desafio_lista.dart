
import 'package:flutter/material.dart';

import '../widgets/cartao_estudante.dart';

class DesafioLista extends StatelessWidget {
  const DesafioLista({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PPDM - Identificacao Estudantil',
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 16.0,
        ),
        child: Column(
          children: const [
            CartaoEstudante(
              nome: 'Ana Silva Santos',
              curso: 'Desenvolvimento Mobile / PPDM',
              ra: '2026109923',
              email: 'ana.silva@estudante.edu.br',
              fotoUrl: 'https://i.pravatar.cc/150?img=47',
            ),

            SizedBox(height: 24.0),

            CartaoEstudante(
              nome: 'Carlos Oliveira',
              curso: 'Analise e Desenvolvimento de Sistemas',
              ra: '2026109924',
              email: 'carlos.oliveira@estudante.edu.br',
              fotoUrl: 'https://i.pravatar.cc/150?img=12',
            ),

            SizedBox(height: 24.0),

            CartaoEstudante(
              nome: 'Mariana Costa',
              curso: 'Desenvolvimento Mobile / PPDM',
              ra: '2026109925',
              email: 'mariana.costa@estudante.edu.br',
              fotoUrl: 'https://i.pravatar.cc/150?img=44',
            ),
          ],
        ),
      ),
    );
  }
}

