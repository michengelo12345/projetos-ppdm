
class Cotacao {
  final double valor;
  final double maxima;
  final double minima;
  final double variacao;
  final String dataAtualizacao;

  Cotacao({
    required this.valor,
    required this.maxima,
    required this.minima,
    required this.variacao,
    required this.dataAtualizacao,
  });

  factory Cotacao.fromJson(Map<String, dynamic> json) {
    return Cotacao(
      valor: double.parse(json['bid'].toString()),
      maxima: double.parse(json['high'].toString()),
      minima: double.parse(json['low'].toString()),
      variacao: double.parse(
        json['pctChange'].toString(),
      ),
      dataAtualizacao: json['create_date'] ?? '',
    );
  }
}

