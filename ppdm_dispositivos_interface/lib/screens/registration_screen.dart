import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Controllers permitem acessar o conteúdo digitado nos campos.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();

  String? _registeredName;
  String? _registeredProfession;

  @override
  void dispose() {
    // Libera os recursos dos controllers quando a tela é descartada.
    _nameController.dispose();
    _professionController.dispose();
    super.dispose();
  }

  void _register() {
    final name = _nameController.text.trim();
    final profession = _professionController.text.trim();

    if (name.isEmpty || profession.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha o nome e a profissão antes de continuar.'),
        ),
      );
      return;
    }

    // setState informa ao Flutter que os dados exibidos foram alterados.
    setState(() {
      _registeredName = name;
      _registeredProfession = profession;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro Interativo'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Preencha seus dados',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Informe seu nome e o cargo ou profissão desejada.',
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      hintText: 'Digite seu nome',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _professionController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Profissão / Cargo desejado',
                      hintText: 'Ex.: Desenvolvedor Flutter',
                      prefixIcon: Icon(Icons.work_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 22),
                  ElevatedButton.icon(
                    onPressed: _register,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Cadastrar'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                  if (_registeredName != null &&
                      _registeredProfession != null) ...[
                    const SizedBox(height: 24),
                    Card(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.waving_hand_outlined),
                                SizedBox(width: 8),
                                Text(
                                  'Cadastro realizado!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Bem-vindo(a), $_registeredName! '
                              'Cargo cadastrado: $_registeredProfession',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
