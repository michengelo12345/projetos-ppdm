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
        backgroundColor: Colors.blueGrey[900],
        appBar: AppBar(
          title: const Text('Crachá Digital'),
          centerTitle: true,
          backgroundColor: Colors.blueGrey[800],
        ),
        body: const Center(
          child: CartaoCracha(),
        ),
      ),
    );
  }
}

class CartaoCracha extends StatelessWidget {
  const CartaoCracha({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Exercício 4: fundo em gradiente (não use color junto com gradient)
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFE3F2FD),
            Color(0xFFCFD8DC),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Exercício 1: foto real com NetworkImage
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blueAccent,
            backgroundImage: NetworkImage(
              'https://images.tcdn.com.br/img/img_prod/741699/camera_eos_r100_com_lente_rf_s_18_45mm_1345_1_51837b084549d00c74f47876367b1a42.jpg',
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Michelangelo',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Text(
            'Desenvolvedor(a) Flutter',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          const Divider(height: 30, thickness: 1),
          // Exercício 2: seção Sobre Mim
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Desenvolvedor Mobile apaixonado pelo ecossistema Flutter & Dart 🚀. Transformo linhas de código em interfaces responsivas e aplicativos de alta performance para Android e iOS. Focado em código limpo, arquitetura escalável e na melhor experiência para o usuário final.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Estudante de desenvolvimento mobile. Gosto de criar interfaces simples e funcionais com Flutter e Dart.',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 14),
          // Exercício 3: habilidades com Chip dentro de uma Row
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Chip(
                label: Text('Flutter'),
                avatar: Icon(Icons.flutter_dash, size: 18),
                visualDensity: VisualDensity.compact,
                backgroundColor: Color(0xFFBBDEFB),
              ),
              Chip(
                label: Text('Dart'),
                avatar: Icon(Icons.code, size: 18),
                visualDensity: VisualDensity.compact,
                backgroundColor: Color(0xFFC8E6C9),
              ),
              Chip(
                label: Text('Git'),
                avatar: Icon(Icons.account_tree, size: 18),
                visualDensity: VisualDensity.compact,
                backgroundColor: Color(0xFFFFE0B2),
              ),
            ],
          ),
          const Divider(height: 30, thickness: 1),
          const Row(
            children: [
              Icon(Icons.email, color: Colors.blueAccent),
              SizedBox(width: 10),
              Text('dev@email.com'),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Icon(Icons.phone, color: Colors.blueAccent),
              SizedBox(width: 10),
              Text('+55 (11) 99999-9999'),
            ],
          ),
        ],
      ),
    );
  }
}
