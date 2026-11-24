
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cotacao.dart';

class CotacaoService {
  static Future<Cotacao> buscarDolar() async {
    final url = Uri.parse(
      'https://economia.awesomeapi.com.br/json/last/USD-BRL',
    );

    try {
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception(
          'Falha ao consultar a cotação do Dólar.',
        );
      }

      final Map<String, dynamic> dados =
          jsonDecode(response.body);

      if (!dados.containsKey('USDBRL')) {
        throw Exception(
          'Dados da cotação não encontrados.',
        );
      }

      return Cotacao.fromJson(
        dados['USDBRL'] as Map<String, dynamic>,
      );
    } on Exception {
      rethrow;
    } catch (_) {
      throw Exception(
        'Não foi possível consultar a cotação.',
      );
    }
  }
}

