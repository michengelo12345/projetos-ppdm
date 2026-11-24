
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class ApiResult<T> {
  final T data;
  final int statusCode;

  const ApiResult({
    required this.data,
    required this.statusCode,
  });
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() {
    if (statusCode != null) {
      return '$message (HTTP $statusCode)';
    }

    return message;
  }
}

class PostService {
  static const String baseUrl =
      'https://jsonplaceholder.typicode.com/posts';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  // GET: Listar postagens.
  static Future<ApiResult<List<Post>>> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?_limit=10'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);

        final posts = body.map((json) {
          return Post.fromJson(json as Map<String, dynamic>);
        }).toList();

        return ApiResult<List<Post>>(
          data: posts,
          statusCode: response.statusCode,
        );
      }

      throw ApiException(
        message: 'Falha ao carregar postagens.',
        statusCode: response.statusCode,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Erro de conexão ao carregar postagens: $e',
      );
    }
  }

  // POST: Criar postagem.
  static Future<ApiResult<Post>> createPost(Post post) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode(post.toJson()),
      );

      if (response.statusCode == 201) {
        final novoPost = Post.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );

        return ApiResult<Post>(
          data: novoPost,
          statusCode: response.statusCode,
        );
      }

      throw ApiException(
        message: 'Falha ao criar nova postagem.',
        statusCode: response.statusCode,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Erro de conexão ao criar postagem: $e',
      );
    }
  }

  // PUT: Atualizar postagem.
  static Future<ApiResult<Post>> updatePost(
    int id,
    Post post,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: headers,
        body: jsonEncode(post.toJson()),
      );

      if (response.statusCode == 200) {
        final postAtualizado = Post.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );

        return ApiResult<Post>(
          data: postAtualizado,
          statusCode: response.statusCode,
        );
      }

      throw ApiException(
        message: 'Falha ao atualizar postagem.',
        statusCode: response.statusCode,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Erro de conexão ao atualizar postagem: $e',
      );
    }
  }

  // DELETE: Remover postagem.
  static Future<ApiResult<void>> deletePost(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
      );

      if (response.statusCode == 200) {
        return ApiResult<void>(
          data: null,
          statusCode: response.statusCode,
        );
      }

      throw ApiException(
        message: 'Falha ao excluir postagem.',
        statusCode: response.statusCode,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Erro de conexão ao excluir postagem: $e',
      );
    }
  }
}

