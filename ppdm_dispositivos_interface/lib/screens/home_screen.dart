import 'package:flutter/material.dart';

import 'catalog_screen.dart';
import 'profile_screen.dart';
import 'registration_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PPDM - Exercícios'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.phone_android,
                    size: 76,
                    color: Color(0xFF176B5B),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Dispositivos Móveis e Criação de Interface',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selecione um exercício para visualizar sua implementação.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  _ExerciseButton(
                    icon: Icons.person,
                    title: 'Exercício 1 - Meu Perfil Dev',
                    subtitle: 'Scaffold, CircleAvatar, Column e Row',
                    onPressed: () => _openScreen(
                      context,
                      const ProfileScreen(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _ExerciseButton(
                    icon: Icons.view_list,
                    title: 'Exercício 2 - Catálogo Dinâmico',
                    subtitle: 'ListView.builder, Card e ListTile',
                    onPressed: () => _openScreen(
                      context,
                      const CatalogScreen(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _ExerciseButton(
                    icon: Icons.assignment,
                    title: 'Exercício 3 - Formulário Interativo',
                    subtitle: 'TextFormField, controllers e setState',
                    onPressed: () => _openScreen(
                      context,
                      const RegistrationScreen(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExerciseButton extends StatelessWidget {
  const _ExerciseButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onPressed,
      ),
    );
  }
}
