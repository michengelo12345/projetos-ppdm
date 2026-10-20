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
      title: 'PPDM - Avaliação 02 (Layout Widgets)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
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
        title: const Text('PPDM - Dashboard de Observações'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // DESAFIO 2: centraliza os elementos da Column principal.
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Resumo das Observações',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),

            // DESAFIO 1: três cards na Row, utilizando Expanded
            // por meio do componente BlocoEstatistica.
            //
            // DESAFIO 7: a primeira linha foi componentizada.
            Row(
              children: const [
                BlocoEstatistica(
                  icone: Icons.flutter_dash,
                  valor: '124',
                  rotulo: 'Aves Vistas',
                  corFundo: Color(0xFFB2DFDB),
                ),
                SizedBox(width: 12.0),
                BlocoEstatistica(
                  icone: Icons.place,
                  valor: '18',
                  rotulo: 'Locais Visitados',
                  corFundo: Color(0xFFE0F2F1),
                ),
                SizedBox(width: 12.0),
                BlocoEstatistica(
                  icone: Icons.camera_alt,
                  valor: '45',
                  rotulo: 'Fotos',
                  corFundo: Color(0xFFB2DFDB),
                ),
              ],
            ),

            const SizedBox(height: 24.0),

            const Text(
              'Destaque da Semana',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),

            // DESAFIOS 5 e 6: Stack com dois selos e Card elevado.
            Stack(
              clipBehavior: Clip.none,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 48,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gavião-Real',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Avistado no Parque Central',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Selo Raro, no canto superior direito.
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

                // DESAFIO 5: selo Confirmado, no canto inferior esquerdo.
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

            const SizedBox(height: 24.0),

            // DESAFIO 3: seção Últimos Registros.
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.list_alt, color: Colors.teal),
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
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Seção de últimos registros selecionada.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                    tooltip: 'Ver registros',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16.0),

            // DESAFIO 4: demonstração documentada de RenderFlex overflow.
            //
            // Uma Row pode causar overflow quando a soma das larguras
            // dos filhos excede a largura disponível.
            //
            // Exemplo de reprodução:
            //
            // Row(
            //   children: [
            //     Container(width: 250, height: 50),
            //     Container(width: 250, height: 50),
            //   ],
            // )
            //
            // Correções possíveis:
            // - Utilizar Expanded ou Flexible.
            // - Reorganizar os elementos em uma grade.
            // - Adaptar o layout à largura disponível.
            //
            // O exemplo permanece comentado para manter a tela funcional.
          ],
        ),
      ),
    );
  }
}
