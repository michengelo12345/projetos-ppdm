
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const PreferenciaApp());
}

class PreferenciaApp extends StatefulWidget {
  const PreferenciaApp({super.key});

  @override
  State<PreferenciaApp> createState() => _PreferenciaAppState();
}

class _PreferenciaAppState extends State<PreferenciaApp> {
  bool _temaEscuro = false;
  bool _receberNotificacoes = true;
  bool _carregando = true;

  String _tamanhoFonte = 'Médio';

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  // Carrega todas as preferências salvas.
  Future<void> _carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _temaEscuro = prefs.getBool('isDark') ?? false;
      _receberNotificacoes =
          prefs.getBool('receberNotificacoes') ?? true;
      _tamanhoFonte = prefs.getString('tamanhoFonte') ?? 'Médio';
      _carregando = false;
    });
  }

  // Altera e salva o tema.
  Future<void> _alternarTema(bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', valor);

    if (!mounted) return;

    setState(() {
      _temaEscuro = valor;
    });
  }

  // Altera e salva o tamanho da fonte.
  Future<void> _alterarTamanhoFonte(String valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tamanhoFonte', valor);

    if (!mounted) return;

    setState(() {
      _tamanhoFonte = valor;
    });
  }

  // Altera e salva a preferência de notificações.
  Future<void> _alternarNotificacoes(bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('receberNotificacoes', valor);

    if (!mounted) return;

    setState(() {
      _receberNotificacoes = valor;
    });
  }

  // Limpa todas as preferências armazenadas.
  Future<void> _limparConfiguracoes() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    if (!mounted) return;

    setState(() {
      _temaEscuro = false;
      _receberNotificacoes = true;
      _tamanhoFonte = 'Médio';
    });
  }

  // Define o fator de escala da fonte.
  double get _fatorFonte {
    switch (_tamanhoFonte) {
      case 'Pequeno':
        return 0.85;
      case 'Grande':
        return 1.25;
      default:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Preferências do Usuário',
      debugShowCheckedModeBanner: false,
      theme: _temaEscuro
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);

        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: TextScaler.linear(_fatorFonte),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: _carregando
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ConfigScreen(
              temaEscuro: _temaEscuro,
              tamanhoFonte: _tamanhoFonte,
              receberNotificacoes: _receberNotificacoes,
              onTemaAlterado: _alternarTema,
              onTamanhoFonteAlterado: _alterarTamanhoFonte,
              onNotificacoesAlteradas: _alternarNotificacoes,
              onLimparConfiguracoes: _limparConfiguracoes,
            ),
    );
  }
}

class ConfigScreen extends StatefulWidget {
  final bool temaEscuro;
  final String tamanhoFonte;
  final bool receberNotificacoes;

  final ValueChanged<bool> onTemaAlterado;
  final ValueChanged<String> onTamanhoFonteAlterado;
  final ValueChanged<bool> onNotificacoesAlteradas;
  final Future<void> Function() onLimparConfiguracoes;

  const ConfigScreen({
    super.key,
    required this.temaEscuro,
    required this.tamanhoFonte,
    required this.receberNotificacoes,
    required this.onTemaAlterado,
    required this.onTamanhoFonteAlterado,
    required this.onNotificacoesAlteradas,
    required this.onLimparConfiguracoes,
  });

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final TextEditingController _nomeController =
      TextEditingController();

  String _nomeSalvo = '';

  @override
  void initState() {
    super.initState();
    _carregarNome();
  }

  // Recupera o nome armazenado.
  Future<void> _carregarNome() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _nomeSalvo = prefs.getString('usuario_nome') ?? 'Não informado';
      _nomeController.text = prefs.getString('usuario_nome') ?? '';
    });
  }

  // Salva o nome do usuário.
  Future<void> _salvarNome() async {
    final nome = _nomeController.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite um nome antes de salvar.'),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('usuario_nome', nome);

    if (!mounted) return;

    setState(() {
      _nomeSalvo = nome;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nome salvo localmente com sucesso!'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  // Limpa as preferências e restaura os valores padrão.
  Future<void> _limparConfiguracoes() async {
    await widget.onLimparConfiguracoes();

    if (!mounted) return;

    setState(() {
      _nomeController.clear();
      _nomeSalvo = 'Não informado';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todas as configurações foram limpas!'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  // Ícone correspondente ao tema.
  IconData _temaEscuroIcone() {
    return widget.temaEscuro
        ? Icons.dark_mode
        : Icons.light_mode;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações Locais'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PREFERÊNCIA DE TEMA
            Card(
              child: SwitchListTile(
                title: const Text('Modo Escuro'),
                subtitle: const Text(
                  'Ativar visual escuro na aplicação',
                ),
                secondary: Icon(_temaEscuroIcone()),
                value: widget.temaEscuro,
                onChanged: widget.onTemaAlterado,
              ),
            ),

            const SizedBox(height: 12),

            // PREFERÊNCIA DE NOTIFICAÇÕES
            Card(
              child: SwitchListTile(
                title: const Text('Receber Notificações'),
                subtitle: const Text(
                  'Ativar ou desativar notificações',
                ),
                secondary: const Icon(Icons.notifications),
                value: widget.receberNotificacoes,
                onChanged: widget.onNotificacoesAlteradas,
              ),
            ),

            const SizedBox(height: 24),

            // PERFIL DO USUÁRIO
            const Text(
              'Perfil do Usuário',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Usuário',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _salvarNome,
                icon: const Icon(Icons.save),
                label: const Text('Salvar Nome'),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Valor atual salvo no disco: $_nomeSalvo',
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),

            const Divider(height: 40),

            // PREFERÊNCIA DE TAMANHO DA FONTE
            const Text(
              'Acessibilidade',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: widget.tamanhoFonte,
              decoration: const InputDecoration(
                labelText: 'Tamanho da Fonte',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.text_fields),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Pequeno',
                  child: Text('Pequeno'),
                ),
                DropdownMenuItem(
                  value: 'Médio',
                  child: Text('Médio'),
                ),
                DropdownMenuItem(
                  value: 'Grande',
                  child: Text('Grande'),
                ),
              ],
              onChanged: (valor) {
                if (valor != null) {
                  widget.onTamanhoFonteAlterado(valor);
                }
              },
            ),

            const SizedBox(height: 12),

            const Text(
              'O tamanho escolhido será aplicado aos textos '
              'da aplicação e permanecerá salvo após reiniciar.',
              style: TextStyle(fontSize: 14),
            ),

            const Divider(height: 40),

            // LIMPAR CONFIGURAÇÕES
            const Text(
              'Gerenciamento de Preferências',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _limparConfiguracoes,
                icon: const Icon(Icons.delete_forever),
                label: const Text('Limpar Configurações'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.all(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

