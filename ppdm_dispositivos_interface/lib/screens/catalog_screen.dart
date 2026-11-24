import 'package:flutter/material.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  static const List<_CatalogItem> items = [
    _CatalogItem(
      title: 'Desenvolvimento Flutter',
      description: 'Criação de aplicativos usando Dart e Flutter.',
      icon: Icons.flutter_dash,
      color: Color(0xFFE1F2FA),
    ),
    _CatalogItem(
      title: 'Lógica de Programação',
      description: 'Algoritmos, condições, repetições e resolução de problemas.',
      icon: Icons.account_tree,
      color: Color(0xFFE8E5FA),
    ),
    _CatalogItem(
      title: 'Banco de Dados',
      description: 'Organização, consulta e persistência de informações.',
      icon: Icons.storage,
      color: Color(0xFFE2F1E5),
    ),
    _CatalogItem(
      title: 'Desenvolvimento Web',
      description: 'Construção de páginas e sistemas para a internet.',
      icon: Icons.language,
      color: Color(0xFFFFEEDB),
    ),
    _CatalogItem(
      title: 'Versionamento com Git',
      description: 'Histórico de alterações e colaboração em projetos.',
      icon: Icons.commit,
      color: Color(0xFFFBE3E7),
    ),
    _CatalogItem(
      title: 'Interface e Experiência',
      description: 'Organização visual, acessibilidade e usabilidade.',
      icon: Icons.design_services,
      color: Color(0xFFE0F1F0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Estudos'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              leading: CircleAvatar(
                radius: 26,
                backgroundColor: item.color,
                child: Icon(
                  item.icon,
                  color: const Color(0xFF176B5B),
                ),
              ),
              title: Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(item.description),
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}

class _CatalogItem {
  const _CatalogItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
}
