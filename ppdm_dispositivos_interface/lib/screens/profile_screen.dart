import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Personalize estes dois valores com seus dados.
  static const String developerName = 'Seu Nome';
  static const String developerEmail = 'seu.email@exemplo.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil Dev'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 54,
                        backgroundColor: Color(0xFFDCEFEA),
                        child: Icon(
                          Icons.person,
                          size: 62,
                          color: Color(0xFF176B5B),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        developerName,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF176B5B),
                            ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Estudante de Desenvolvimento de Sistemas',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const Divider(height: 32),
                      _ProfileInfoRow(
                        icon: Icons.schedule,
                        label: 'Turno',
                        value: 'Noturno',
                      ),
                      const SizedBox(height: 18),
                      _ProfileInfoRow(
                        icon: Icons.groups,
                        label: 'Turma',
                        value: 'T2DEV-T3',
                      ),
                      const SizedBox(height: 18),
                      _ProfileInfoRow(
                        icon: Icons.email_outlined,
                        label: 'E-mail',
                        value: developerEmail,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF176B5B)),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
