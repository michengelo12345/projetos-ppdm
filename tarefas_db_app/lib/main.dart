
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'database/database_helper.dart';
import 'models/tarefa.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuração do SQLite para Flutter Web.
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  runApp(const TarefasDbApp());
}

class TarefasDbApp extends StatelessWidget {
  const TarefasDbApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas SQLite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7F7),
      ),
      home: const TarefasScreen(),
    );
  }
}

class TarefasScreen extends StatefulWidget {
  const TarefasScreen({super.key});

  @override
  State<TarefasScreen> createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  List<Tarefa> _tarefas = [];

  bool _carregando = true;

  String _busca = '';

  int _totalTarefas = 0;

  int _contadorConsultas = 0;

  final TextEditingController _buscaController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  // Consultar tarefas e atualizar contador.
  Future<void> _atualizarLista() async {
    final consultaAtual = ++_contadorConsultas;

    if (mounted) {
      setState(() {
        _carregando = true;
      });
    }

    try {
      final resultados = await Future.wait([
        _busca.trim().isEmpty
            ? DatabaseHelper.instance.queryAll()
            : DatabaseHelper.instance.search(_busca),
        DatabaseHelper.instance.countAll(),
      ]);

      final dados = resultados[0] as List<Tarefa>;
      final total = resultados[1] as int;

      if (!mounted || consultaAtual != _contadorConsultas) {
        return;
      }

      setState(() {
        _tarefas = dados;
        _totalTarefas = total;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted || consultaAtual != _contadorConsultas) {
        return;
      }

      setState(() {
        _carregando = false;
      });

      _mostrarMensagem('Erro ao consultar tarefas: $e');
    }
  }

  // Exibir mensagens.
  void _mostrarMensagem(String mensagem) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mensagem),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // Cadastrar tarefa.
  Future<void> _adicionarTarefa(String titulo) async {
    if (titulo.trim().isEmpty) {
      _mostrarMensagem(
        'Digite uma descrição para a tarefa.',
      );
      return;
    }

    try {
      await DatabaseHelper.instance.insert(
        Tarefa(titulo: titulo.trim()),
      );

      _busca = '';
      _buscaController.clear();

      await _atualizarLista();

      if (!mounted) return;

      _mostrarMensagem(
        'Tarefa cadastrada com sucesso!',
      );
    } catch (e) {
      _mostrarMensagem(
        'Erro ao cadastrar tarefa: $e',
      );
    }
  }

  // Alterar status da tarefa.
  Future<void> _alternarStatus(Tarefa tarefa) async {
    try {
      final atualizada = tarefa.copyWith(
        concluida: !tarefa.concluida,
      );

      await DatabaseHelper.instance.update(atualizada);

      await _atualizarLista();

      if (!mounted) return;

      _mostrarMensagem(
        atualizada.concluida
            ? 'Tarefa concluída!'
            : 'Tarefa reaberta!',
      );
    } catch (e) {
      _mostrarMensagem(
        'Erro ao atualizar tarefa: $e',
      );
    }
  }

  // Excluir tarefa individualmente.
  Future<void> _removerTarefa(int id) async {
    try {
      await DatabaseHelper.instance.delete(id);

      await _atualizarLista();

      if (!mounted) return;

      _mostrarMensagem(
        'Tarefa removida com sucesso!',
      );
    } catch (e) {
      _mostrarMensagem(
        'Erro ao remover tarefa: $e',
      );
    }
  }

  // EXERCÍCIO 02: Limpar todas as tarefas.
  Future<void> _limparTodasTarefas() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text(
            'Limpar todas as tarefas?',
          ),
          content: const Text(
            'Tem certeza de que deseja excluir todos '
            'os registros do banco de dados? '
            'Essa operação não poderá ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(ctx, true);
              },
              child: const Text('Excluir tudo'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    try {
      final quantidade =
          await DatabaseHelper.instance.deleteAll();

      _busca = '';
      _buscaController.clear();

      await _atualizarLista();

      if (!mounted) return;

      _mostrarMensagem(
        '$quantidade tarefa(s) removida(s) com sucesso!',
      );
    } catch (e) {
      _mostrarMensagem(
        'Erro ao limpar tarefas: $e',
      );
    }
  }

  // EXERCÍCIO 03: Pesquisar tarefas.
  void _pesquisarTarefas(String texto) {
    _busca = texto;
    _atualizarLista();
  }

  // Exibir formulário de cadastro.
  Future<void> _exibirDialogCadastro() async {
    final controller = TextEditingController();

    final titulo = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Nova Tarefa (SQLite)'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Descrição da tarefa',
              hintText: 'Ex.: Estudar Flutter',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.edit),
            ),
            onSubmitted: (valor) {
              Navigator.pop(ctx, valor);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx, controller.text);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (titulo != null && mounted) {
      await _adicionarTarefa(titulo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Persistência Relacional (SQLite)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Limpar todas as tarefas',
            icon: const Icon(Icons.delete_sweep),
            onPressed: _tarefas.isEmpty
                ? null
                : _limparTodasTarefas,
          ),
        ],
      ),

      body: Column(
        children: [
          // Campo de pesquisa.
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _buscaController,
              onChanged: _pesquisarTarefas,
              decoration: InputDecoration(
                hintText: 'Pesquisar tarefas...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.teal,
                ),
                suffixIcon: _busca.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _buscaController.clear();
                          _pesquisarTarefas('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Lista de tarefas.
          Expanded(
            child: _carregando
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.teal,
                    ),
                  )
                : _tarefas.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(
                                _busca.isNotEmpty
                                    ? Icons.search_off
                                    : Icons.task_alt,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _busca.isNotEmpty
                                    ? 'Nenhuma tarefa encontrada.'
                                    : 'Nenhuma tarefa salva no banco local.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(
                          left: 12,
                          right: 12,
                          bottom: 12,
                        ),
                        itemCount: _tarefas.length,
                        itemBuilder: (ctx, i) {
                          final tarefa = _tarefas[i];

                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                            ),
                            elevation: 2,
                            child: ListTile(
                              leading: Checkbox(
                                value: tarefa.concluida,
                                activeColor: Colors.teal,
                                onChanged: (_) {
                                  _alternarStatus(tarefa);
                                },
                              ),
                              title: Text(
                                tarefa.titulo,
                                style: TextStyle(
                                  decoration: tarefa.concluida
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: tarefa.concluida
                                      ? Colors.grey
                                      : Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                tarefa.concluida
                                    ? 'Concluída'
                                    : 'Pendente',
                                style: TextStyle(
                                  color: tarefa.concluida
                                      ? Colors.teal
                                      : Colors.orange,
                                ),
                              ),
                              trailing: IconButton(
                                tooltip: 'Excluir tarefa',
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  if (tarefa.id != null) {
                                    _removerTarefa(tarefa.id!);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ),

          // EXERCÍCIO 01: Contador de tarefas.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: const BoxDecoration(
              color: Colors.teal,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.storage,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Text(
                  'Total de tarefas registradas: $_totalTarefas',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Botão de adicionar tarefa.
      floatingActionButton: FloatingActionButton(
        onPressed: _exibirDialogCadastro,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        tooltip: 'Adicionar tarefa',
        child: const Icon(Icons.add),
      ),
    );
  }
}

