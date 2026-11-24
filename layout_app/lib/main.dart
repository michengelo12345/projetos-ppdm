
import 'package:flutter/material.dart';

import 'widgets/bloco_estatistica.dart';

void main() {
  runApp(const MeuLayoutApp());
}

class MeuLayoutApp extends StatelessWidget {
  const MeuLayoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PPDM - Layout Widgets',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        useMaterial3: true,
      ),
      home: const TelaDashboard(),
    );
  }
}

class TelaDashboard extends StatelessWidget {
  const TelaDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PPDM - Dashboard de Observações',
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // TÍTULO PRINCIPAL
            const Text(
              'Resumo das Observações',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16.0),

            // EXERCÍCIO 08: GRIDVIEW.COUNT
            // Grade com 2 colunas e 4 cards.
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,

              children: [
                // CARD 1
                BlocoEstatistica(
                  icone: Icons.flutter_dash,
                  quantidade: '124',
                  legenda: 'Aves Vistas',
                  cor: Colors.teal.shade100,
                ),

                // CARD 2
                BlocoEstatistica(
                  icone: Icons.place,
                  quantidade: '18',
                  legenda: 'Locais Visitados',
                  cor: Colors.teal.shade50,
                ),

                // CARD 3
                BlocoEstatistica(
                  icone: Icons.camera_alt,
                  quantidade: '45',
                  legenda: 'Fotos',
                  cor: Colors.teal.shade200,
                ),

                // CARD 4
                BlocoEstatistica(
                  icone: Icons.list_alt,
                  quantidade: '32',
                  legenda: 'Observações',
                  cor: Colors.teal.shade300,
                ),
              ],
            ),

            const SizedBox(height: 24.0),

            // SEÇÃO DE DESTAQUE
            const Text(
              'Destaque da Semana',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16.0),

            // EXERCÍCIOS 05 E 06:
            // STACK COM DOIS SELOS E CARD COM ELEVAÇÃO.
            Stack(
              clipBehavior: Clip.none,
              children: [

                // CARD PRINCIPAL
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),

                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 48,
                          color: Colors.amber,
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Gavião-Real',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text(
                                'Avistado no Parque Central',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // SELO RARO
                Positioned(
                  top: -8,
                  right: -8,

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: const Text(
                      'Raro',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // SELO CONFIRMADO
                Positioned(
                  bottom: -8,
                  left: -8,

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: const Text(
                      'Confirmado',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32.0),

            // EXERCÍCIO 03:
            // SEÇÃO ÚLTIMOS REGISTROS.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),

              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  // ÍCONE E TEXTO
                  const Row(
                    children: [
                      Icon(
                        Icons.list_alt,
                        color: Colors.teal,
                        size: 28,
                      ),

                      SizedBox(width: 8),

                      Text(
                        'Últimos Registros',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // BOTÃO
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Exibindo últimos registros!',
                          ),
                        ),
                      );
                    },

                    child: const Text('Ver'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

