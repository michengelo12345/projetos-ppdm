//#   PROVA PRÁTICA (29/09/2026) — `prova_cracha_app`

//### Estrutura do Código da Avaliação (`lib/main.dart`)

//    *(Você aluno deve copiar a pasta `prova_cracha_app` e completar os desafios abaixo)*

import 'package:flutter/material.dart';

void main() {
  runApp(const MeuCrachaApp());
}

class MeuCrachaApp extends StatelessWidget {
  const MeuCrachaApp({super.key});

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
              // DESAFIO 5 (3 PONTOS) - DECORAÇÃO E GRADIENTE
              // Configure o fundo com LinearGradient aplicando
              // Colors.indigo e Colors.blueAccent.
              // ===============================================================
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF455A64),
                  Color(0xFF263238),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                // ===============================================================
                // DESAFIO 1 (3 PONTOS) - FOTO DE PERFIL
                // Adicione a imagem via NetworkImage no CircleAvatar.
                // ===============================================================
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://thumb.wikimedia.org/wikipedia/commons/thumb/c/c2/GitHub_Invertocat_Logo.svg/250px-GitHub_Invertocat_Logo.svg.png?utm_source=pt.wikipedia.org&utm_campaign=parser&utm_content=thumbnail',
                  ),
                  // TODO: Adicionar propriedade backgroundImage com NetworkImage
                ),
                
                const SizedBox(height: 15),
                
                const Text(
                  'Michelangelo Rasa Neto',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                // ===============================================================
                // DESAFIO 2 (3 PONTOS) - ESTILIZAÇÃO E BIOGRAFIA
                // Adicione a propriedade para fonte em itálico (fontStyle).
                // ===============================================================
                const Text(
                  'Desenvolvedor Mobile Flutter / SENAI',
                  style: TextStyle(
                    color: Colors.white70,
                    // TODO: Inserir fontStyle: FontStyle.italic
                  ),
                ),
                
                const Divider(color: Colors.white38, height: 30),
                
                // ===============================================================
                // DESAFIO 3 (3 PONTOS) - ALINHAMENTO DE SKILLS (ROW)
                // Alinhe ao centro e crie os 3 Chips: 'Dart', 'Flutter', 'Git'.
                // ===============================================================
                const Row(
                  // TODO: Adicionar mainAxisAlignment: MainAxisAlignment.center
                  children: [
                    Chip(label: Text('Dart')),
                    SizedBox(width: 5),
                    // TODO: Adicionar o Chip 'Flutter',
                    SizedBox(width: 5),
                    // TODO: Adicionar o Chip 'Git',
                  ],
                ),
                
                const SizedBox(height: 15),
                
                // ===============================================================
                // DESAFIO 4 (3 PONTOS) - COMPILAÇÃO E ESTRUTURA
                // Garanta que o projeto prova_cracha_app compila sem erros no Debian.
                // ===============================================================
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ### Formulário de Coleta (Google Forms - 29/09)

// No formulário de entrega, você aluno deve enviar:

// 1. **Seu Nome Completo**

// 2. **Link do Repositório GitHub:** `[https://github.com/USUARIO/prova_cracha_app](https://github.com/USUARIO/prova_cracha_app)`

// 3. **Upload do arquivo `main.dart**`

// 4. **Upload do Captura de Tela (Print)** do app rodando no servidor Debian (`http://<IP_DEBIAN>:8080`). Obs. Importante ! Caso NÃO funcione na porta 8080, troque a porta por outra, por exemplo, 8081....

