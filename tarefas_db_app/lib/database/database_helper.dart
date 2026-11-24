
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/tarefa.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('tarefas_local.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE tarefas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        concluida INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  // Cadastrar tarefa.
  Future<int> insert(Tarefa tarefa) async {
    final db = await database;

    return await db.insert(
      'tarefas',
      tarefa.toMap(),
    );
  }

  // Consultar todas as tarefas.
  Future<List<Tarefa>> queryAll() async {
    final db = await database;

    final result = await db.query(
      'tarefas',
      orderBy: 'id DESC',
    );

    return result.map((json) => Tarefa.fromMap(json)).toList();
  }

  // EXERCÍCIO 03: Pesquisar tarefas pelo título.
  Future<List<Tarefa>> search(String texto) async {
    final db = await database;

    final termo = texto.trim();

    if (termo.isEmpty) {
      return await queryAll();
    }

    final result = await db.query(
      'tarefas',
      where: 'titulo LIKE ?',
      whereArgs: ['%$termo%'],
      orderBy: 'id DESC',
    );

    return result.map((json) => Tarefa.fromMap(json)).toList();
  }

  // Atualizar tarefa.
  Future<int> update(Tarefa tarefa) async {
    final db = await database;

    return await db.update(
      'tarefas',
      tarefa.toMap(),
      where: 'id = ?',
      whereArgs: [tarefa.id],
    );
  }

  // Excluir tarefa individualmente.
  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      'tarefas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // EXERCÍCIO 02: Excluir todas as tarefas.
  Future<int> deleteAll() async {
    final db = await database;

    return await db.delete('tarefas');
  }

  // EXERCÍCIO 01: Contar todas as tarefas cadastradas.
  Future<int> countAll() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM tarefas',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }
}

