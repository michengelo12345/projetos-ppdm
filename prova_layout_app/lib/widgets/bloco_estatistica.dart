import 'package:flutter/material.dart';

class BlocoEstatistica extends StatelessWidget {
  final IconData icone;
  final String valor;
  final String rotulo;
  final Color corFundo;

  const BlocoEstatistica({
    super.key,
    required this.icone,
    required this.valor,
    required this.rotulo,
    this.corFundo = Colors.teal,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: corFundo,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icone, size: 36, color: Colors.teal),
            const SizedBox(height: 8),
            Text(valor, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(rotulo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}