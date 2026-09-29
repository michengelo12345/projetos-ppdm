// ### 💻 CÓDIGO DA PROVA (`lib/main.dart`)

// *(Complete os trechos marcados com `// TODO: DESAFIO X`)*

import 'package:flutter/material.dart';

void main() {
  runApp(const CrachaApp());
}

class CrachaApp extends StatelessWidget {
  const CrachaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Crachá do Desenvolvedor'),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 8),
              ],
              
              // ===============================================================
              // DESAFIO 5 (VALOR: 20 PONTOS) - DECORAÇÃO E GRADIENTE
              // Configure o fundo do cartão com um LinearGradient aplicando 
              // as cores Colors.indigo e Colors.blueAccent.
              // ===============================================================
              gradient: const LinearGradient(
                colors: [
                  // TODO: Insira a primeira cor aqui,
                  // TODO: Insira a segunda cor aqui,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                // ===============================================================
                // DESAFIO 1 (VALOR: 20 PONTOS) - FOTO DE PERFIL
                // Adicione a foto de perfil usando um CircleAvatar com raio 50
                // e carregando uma imagem via NetworkImage.
                // ===============================================================
                const CircleAvatar(
                  radius: 50,
                  // TODO: Adicione a propriedade backgroundImage usando NetworkImage
                  // URL de teste: 'https://github.com/identicons/user.png'
                ),
                
                const SizedBox(height: 15),
                
                const Text(
                  'Seu Nome Completo',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                // ===============================================================
                // DESAFIO 2 (VALOR: 20 PONTOS) - ESTILIZAÇÃO E BIOGRAFIA
                // Adicione a biografia/cargo do desenvolvedor em texto itálico
                // e com tamanho de fonte 14.
                // ===============================================================
                const Text(
                  'Desenvolvedor Mobile Flutter / SENAI',
                  style: TextStyle(
                    color: Colors.white70,
                    // TODO: Adicione a propriedade para deixar a fonte em itálico (fontStyle)
                  ),
                ),
                
                const Divider(color: Colors.white38, height: 30),
                
                // ===============================================================
                // DESAFIO 3 (VALOR: 20 PONTOS) - ALINHAMENTO DE SKILLS (ROW)
                // Crie uma linha (Row) com alinhamento horizontal centralizado 
                // contendo 3 Chips com as habilidades: 'Dart', 'Flutter', 'Git'.
                // ===============================================================
                const Row(
                  // TODO: Adicione a propriedade de alinhamento principal no centro
                  children: [
                    Chip(label: Text('Dart')),
                    SizedBox(width: 5),
                    // TODO: Adicione o segundo Chip aqui ('Flutter'),
                    SizedBox(width: 5),
                    // TODO: Adicione o terceiro Chip aqui ('Git'),
                  ],
                ),
                
                const SizedBox(height: 15),
                
                // ===============================================================
                // DESAFIO 4 (VALOR: 20 PONTOS) - COMPILAÇÃO E ESTRUTURA
                // Garanta que todo o código compile sem erros no Debian 
                // e apresente o layout simétrico e alinhado na tela.
                // ===============================================================
              ],
            ),
          ),
        ),
      ),
    );
  }
}

