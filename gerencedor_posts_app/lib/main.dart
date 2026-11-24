
import 'package:flutter/material.dart';

import 'models/post.dart';
import 'services/post_service.dart';

void main() {
  runApp(const GerenciadorPostsApp());
}

class GerenciadorPostsApp extends StatelessWidget {
  const GerenciadorPostsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Posts API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const PostsScreen(),
    );
  }
}

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Post> _posts = [];

  bool _isLoading = true;
  bool _isSaving = false;

  String _searchQuery = '';

  final TextEditingController _searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarPosts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // EXERCICIO 02: FILTRO DE BUSCA LOCAL.

  List<Post> get _filteredPosts {
    if (_searchQuery.isEmpty) {
      return _posts;
    }

    return _posts.where((post) {
      return post.title.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
    }).toList();
  }

  void _atualizarBusca(String value) {
    setState(() {
      _searchQuery = value.trim();
    });
  }

  void _limparBusca() {
    _searchController.clear();

    setState(() {
      _searchQuery = '';
    });
  }

  // SNACKBAR.

  void _mostrarSnackBar(String mensagem, Color cor) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mensagem),
          backgroundColor: cor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
  }

  // EXERCICIO 03: EXIBIR STATUS HTTP.

  String _mensagemStatus(String operacao, int statusCode) {
    return '$operacao - HTTP $statusCode';
  }

  void _mostrarErro(Object erro) {
    _mostrarSnackBar(
      erro.toString(),
      Colors.red,
    );
  }

  // GET: CARREGAR POSTAGENS.

  Future<void> _carregarPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final resultado = await PostService.fetchPosts();

      if (!mounted) return;

      setState(() {
        _posts = resultado.data;
      });

      _mostrarSnackBar(
        _mensagemStatus(
          'Postagens carregadas com sucesso',
          resultado.statusCode,
        ),
        Colors.green,
      );
    } catch (e) {
      _mostrarErro(e);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // FORMULARIO: CRIAR E EDITAR POSTAGENS.

  Future<void> _abrirFormulario({Post? post}) async {
    final titleController = TextEditingController(
      text: post?.title ?? '',
    );

    final bodyController = TextEditingController(
      text: post?.body ?? '',
    );

    try {
      final confirmado = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            post == null
                ? 'Novo Post (POST)'
                : 'Editar Post (PUT)',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  textCapitalization:
                      TextCapitalization.sentences,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: bodyController,
                  decoration: const InputDecoration(
                    labelText: 'Conteúdo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 4,
                  textCapitalization:
                      TextCapitalization.sentences,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx, true);
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      );

      if (confirmado != true || !mounted) return;

      final novoTitle = titleController.text.trim();
      final novoBody = bodyController.text.trim();

      if (novoTitle.isEmpty || novoBody.isEmpty) {
        _mostrarSnackBar(
          'Preencha o título e o conteúdo.',
          Colors.orange,
        );
        return;
      }

      if (_isSaving) return;

      setState(() {
        _isSaving = true;
      });

      if (post == null) {
        await _criarPost(novoTitle, novoBody);
      } else {
        await _editarPost(
          post,
          novoTitle,
          novoBody,
        );
      }
    } finally {
      titleController.dispose();
      bodyController.dispose();

      if (mounted && _isSaving) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // POST: CRIAR POSTAGEM.

  Future<void> _criarPost(String title, String body) async {
    try {
      final resultado = await PostService.createPost(
        Post(
          title: title,
          body: body,
        ),
      );

      if (!mounted) return;

      setState(() {
        _posts.insert(0, resultado.data);
      });

      _mostrarSnackBar(
        _mensagemStatus(
          'Post criado com sucesso',
          resultado.statusCode,
        ),
        Colors.green,
      );
    } catch (e) {
      _mostrarErro(e);
    }
  }

  // PUT: EDITAR POSTAGEM.

  Future<void> _editarPost(
    Post post,
    String title,
    String body,
  ) async {
    try {
      final resultado = await PostService.updatePost(
        post.id!,
        Post(
          id: post.id,
          title: title,
          body: body,
        ),
      );

      if (!mounted) return;

      setState(() {
        final index = _posts.indexWhere(
          (p) => p.id == post.id,
        );

        if (index != -1) {
          _posts[index] = resultado.data;
        }
      });

      _mostrarSnackBar(
        _mensagemStatus(
          'Post atualizado com sucesso',
          resultado.statusCode,
        ),
        Colors.blue,
      );
    } catch (e) {
      _mostrarErro(e);
    }
  }

  // EXERCICIO 01: CONFIRMACAO ANTES DO DELETE.

  Future<void> _confirmarExclusao(Post post) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text('Confirmar exclusão'),
            ),
          ],
        ),
        content: Text(
          'Tem certeza de que deseja excluir esta postagem?\n\n'
          'Título: ${post.title}\n\n'
          'Essa operação não poderá ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx, false);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx, true);
            },
            icon: const Icon(Icons.delete),
            label: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmado == true && mounted) {
      await _deletarPost(post.id!);
    }
  }

  // DELETE: REMOVER POSTAGEM.

  Future<void> _deletarPost(int id) async {
    try {
      final resultado = await PostService.deletePost(id);

      if (!mounted) return;

      setState(() {
        _posts.removeWhere((post) => post.id == id);
      });

      _mostrarSnackBar(
        _mensagemStatus(
          'Post removido com sucesso',
          resultado.statusCode,
        ),
        Colors.orange,
      );
    } catch (e) {
      _mostrarErro(e);
    }
  }

  // INTERFACE PRINCIPAL.

  @override
  Widget build(BuildContext context) {
    final postsExibidos = _filteredPosts;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _atualizarBusca,
          style: const TextStyle(
            color: Colors.white,
          ),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: 'Pesquisar posts pelo título...',
            hintStyle: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
            border: InputBorder.none,
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: _limparBusca,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _carregarPosts,
              child: postsExibidos.isEmpty
                  ? ListView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 120),
                        Icon(
                          Icons.search_off,
                          size: 70,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            _searchQuery.isNotEmpty
                                ? 'Nenhum post encontrado.'
                                : 'Nenhuma postagem disponível.',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          Center(
                            child: TextButton(
                              onPressed: _limparBusca,
                              child: const Text(
                                'Limpar pesquisa',
                              ),
                            ),
                          ),
                      ],
                    )
                  : ListView.builder(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      itemCount: postsExibidos.length,
                      itemBuilder: (ctx, index) {
                        final post = postsExibidos[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          elevation: 2,
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.all(12),
                            title: Text(
                              post.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8),
                              child: Text(
                                post.body,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Editar postagem',
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: _isSaving
                                      ? null
                                      : () {
                                          _abrirFormulario(
                                            post: post,
                                          );
                                        },
                                ),
                                IconButton(
                                  tooltip: 'Excluir postagem',
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _confirmarExclusao(post);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: _isSaving
            ? null
            : () => _abrirFormulario(),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        tooltip: 'Adicionar postagem',
        child: const Icon(Icons.add),
      ),
    );
  }
}

