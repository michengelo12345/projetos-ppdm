
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/endereco.dart';

class ViaCepService {
  static Future<Endereco> buscarCep(String cep) async {
    final cepLimpo = cep.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    if (cepLimpo.length != 8) {
      throw Exception(
        'CEP inválido. Deve conter 8 dígitos.',
      );
    }

    final url = Uri.parse(
      'https://viacep.com.br/ws/$cepLimpo/json/',
    );

    try {
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception(
          'Falha ao conectar com o serviço ViaCEP.',
        );
      }

      final Map<String, dynamic> dados =
          jsonDecode(response.body);

      if (dados['erro'] == true) {
        throw Exception(
          'CEP não encontrado na base de dados.',
        );
      }

      return Endereco.fromJson(dados);
    } on Exception {
      rethrow;
    } catch (_) {
      throw Exception(
        'Não foi possível consultar o CEP. Verifique sua conexão.',
      );
    }
  }
}

