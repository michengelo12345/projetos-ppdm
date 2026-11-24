
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/cotacao.dart';
import 'models/endereco.dart';
import 'services/cotacao_service.dart';
import 'services/via_cep_service.dart';

void main() {
    runApp(const CepApp());
}

class CepApp extends StatelessWidget {
    const CepApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Consulta CEP',
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.blue,
                ),
                useMaterial3: true,
            ),
            home: const HomeScreen(),
        );
    }
}

class CepInputFormatter extends TextInputFormatter {
    @override
    TextEditingValue formatEditUpdate(
        TextEditingValue oldValue,
        TextEditingValue newValue,
    ) {
        final numeros = newValue.text.replaceAll(
            RegExp(r'[^0-9]'),
            '',
        );

        final cep = numeros.length > 8
            ? numeros.substring(0, 8)
            : numeros;

        String textoFormatado = cep;

        if (cep.length > 5) {
            textoFormatado =
                '${cep.substring(0, 5)}-${cep.substring(5)}';
        }

        return TextEditingValue(
            text: textoFormatado,
            selection: TextSelection.collapsed(
                offset: textoFormatado.length,
            ),
        );
    }
}

class HomeScreen extends StatefulWidget {
    const HomeScreen({super.key});

    @override
    State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    final TextEditingController _cepController =
        TextEditingController();

    Endereco? _endereco;
    Cotacao? _cotacao;

    List<Endereco> _historico = [];

    bool _carregandoCep = false;
    bool _carregandoCotacao = false;

    String? _erroCep;
    String? _erroCotacao;

    @override
    void initState() {
        super.initState();
        _carregarHistorico();
        _buscarCotacao();
    }

    @override
    void dispose() {
        _cepController.dispose();
        super.dispose();
    }

    Future<void> _carregarHistorico() async {
        final prefs = await SharedPreferences.getInstance();
        final dados = prefs.getString('historico_ceps');

        if (dados == null) return;

        try {
            final List<dynamic> lista = jsonDecode(dados);

            final historico = lista
                .map(
                    (item) => Endereco.fromJson(
                        Map<String, dynamic>.from(item),
                    ),
                )
                .toList();

            if (!mounted) return;

            setState(() {
                _historico = historico;
            });
        } catch (_) {
            if (!mounted) return;

            setState(() {
                _historico = [];
            });
        }
    }

    Future<void> _salvarHistorico(Endereco endereco) async {
        final prefs = await SharedPreferences.getInstance();

        _historico.removeWhere(
            (item) => item.cep == endereco.cep,
        );

        _historico.insert(0, endereco);

        if (_historico.length > 10) {
            _historico = _historico.sublist(0, 10);
        }

        await prefs.setString(
            'historico_ceps',
            jsonEncode(
                _historico.map((item) => item.toJson()).toList(),
            ),
        );

        if (!mounted) return;

        setState(() {});
    }

    Future<void> _limparHistorico() async {
        final prefs = await SharedPreferences.getInstance();

        await prefs.remove('historico_ceps');

        if (!mounted) return;

        setState(() {
            _historico.clear();
        });
    }

    Future<void> _buscarCep([String? cepInformado]) async {
        final cep = cepInformado ?? _cepController.text;

        final cepLimpo = cep.replaceAll(
            RegExp(r'[^0-9]'),
            '',
        );

        if (cepLimpo.length != 8) {
            setState(() {
                _erroCep = 'Digite um CEP válido com 8 dígitos.';
                _endereco = null;
            });
            return;
        }

        setState(() {
            _carregandoCep = true;
            _erroCep = null;
            _endereco = null;
        });

        try {
            final endereco = await ViaCepService.buscarCep(cepLimpo);

            await _salvarHistorico(endereco);

            if (!mounted) return;

            setState(() {
                _endereco = endereco;
                _cepController.text = endereco.cep;
            });
        } catch (erro) {
            if (!mounted) return;

            setState(() {
                _erroCep = erro.toString().replaceFirst(
                    'Exception: ',
                    '',
                );
            });
        } finally {
            if (mounted) {
                setState(() {
                    _carregandoCep = false;
                });
            }
        }
    }

    Future<void> _buscarCotacao() async {
        setState(() {
            _carregandoCotacao = true;
            _erroCotacao = null;
        });

        try {
            final cotacao = await CotacaoService.buscarDolar();

            if (!mounted) return;

            setState(() {
                _cotacao = cotacao;
            });
        } catch (erro) {
            if (!mounted) return;

            setState(() {
                _erroCotacao = erro.toString().replaceFirst(
                    'Exception: ',
                    '',
                );
            });
        } finally {
            if (mounted) {
                setState(() {
                    _carregandoCotacao = false;
                });
            }
        }
    }

    Widget _campoEndereco(String titulo, String valor) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    SizedBox(
                        width: 115,
                        child: Text(
                            titulo,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                            ),
                        ),
                    ),
                    Expanded(
                        child: Text(
                            valor.isEmpty ? 'Não informado' : valor,
                        ),
                    ),
                ],
            ),
        );
    }

    Widget _cardEndereco() {
        if (_endereco == null) {
            return const SizedBox.shrink();
        }

        final endereco = _endereco!;

        return Card(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        const Row(
                            children: [
                                Icon(
                                    Icons.location_on,
                                    color: Colors.blue,
                                ),
                                SizedBox(width: 8),
                                Text(
                                    'Endereço encontrado',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                    ),
                                ),
                            ],
                        ),
                        const Divider(height: 24),
                        _campoEndereco('CEP:', endereco.cep),
                        _campoEndereco(
                            'Logradouro:',
                            endereco.logradouro,
                        ),
                        _campoEndereco(
                            'Complemento:',
                            endereco.complemento,
                        ),
                        _campoEndereco('Bairro:', endereco.bairro),
                        _campoEndereco(
                            'Cidade:',
                            endereco.localidade,
                        ),
                        _campoEndereco('UF:', endereco.uf),
                    ],
                ),
            ),
        );
    }

    Widget _cardCotacao() {
        return Card(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Row(
                            children: [
                                const Icon(
                                    Icons.currency_exchange,
                                    color: Colors.green,
                                ),
                                const SizedBox(width: 8),
                                const Expanded(
                                    child: Text(
                                        'Cotação do Dólar',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),
                                IconButton(
                                    onPressed: _carregandoCotacao
                                        ? null
                                        : _buscarCotacao,
                                    icon: const Icon(Icons.refresh),
                                    tooltip: 'Atualizar cotação',
                                ),
                            ],
                        ),
                        const Divider(),
                        if (_carregandoCotacao)
                            const Center(
                                child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: CircularProgressIndicator(),
                                ),
                            )
                        else if (_erroCotacao != null)
                            Text(
                                _erroCotacao!,
                                style: const TextStyle(
                                    color: Colors.red,
                                ),
                            )
                        else if (_cotacao != null) ...[
                            Text(
                                'US\$ 1,00 = R\$ ${_cotacao!.valor.toStringAsFixed(4)}',
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                ),
                            ),
                            const SizedBox(height: 12),
                            _campoEndereco(
                                'Máxima:',
                                'R\$ ${_cotacao!.maxima.toStringAsFixed(4)}',
                            ),
                            _campoEndereco(
                                'Mínima:',
                                'R\$ ${_cotacao!.minima.toStringAsFixed(4)}',
                            ),
                            _campoEndereco(
                                'Variação:',
                                '${_cotacao!.variacao.toStringAsFixed(2)}%',
                            ),
                            _campoEndereco(
                                'Atualização:',
                                _cotacao!.dataAtualizacao,
                            ),
                        ] else
                            const Text('Cotação indisponível.'),
                    ],
                ),
            ),
        );
    }

    Widget _cardHistorico() {
        return Card(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Row(
                            children: [
                                const Icon(
                                    Icons.history,
                                    color: Colors.blue,
                                ),
                                const SizedBox(width: 8),
                                const Expanded(
                                    child: Text(
                                        'Histórico de consultas',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),
                                if (_historico.isNotEmpty)
                                    TextButton(
                                        onPressed: _limparHistorico,
                                        child: const Text('Limpar'),
                                    ),
                            ],
                        ),
                        const Divider(),
                        if (_historico.isEmpty)
                            const Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                    'Nenhuma consulta realizada.',
                                ),
                            )
                        else
                            ..._historico.map(
                                (endereco) => ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: const Icon(
                                        Icons.location_on_outlined,
                                    ),
                                    title: Text(endereco.cep),
                                    subtitle: Text(
                                        '${endereco.localidade} - ${endereco.uf}',
                                    ),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                    ),
                                    onTap: () {
                                        _cepController.text =
                                            endereco.cep;
                                        _buscarCep(endereco.cep);
                                    },
                                ),
                            ),
                    ],
                ),
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Consulta de CEP'),
                centerTitle: true,
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                        const Icon(
                            Icons.search,
                            size: 64,
                            color: Colors.blue,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                            'Encontre um endereço',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                            ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                            'Digite o CEP para consultar o endereço.',
                            textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                            controller: _cepController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                CepInputFormatter(),
                            ],
                            maxLength: 9,
                            decoration: const InputDecoration(
                                labelText: 'CEP',
                                hintText: '00000-000',
                                prefixIcon: Icon(Icons.location_on),
                                border: OutlineInputBorder(),
                                counterText: '',
                            ),
                            onSubmitted: (_) => _buscarCep(),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                            onPressed: _carregandoCep
                                ? null
                                : () => _buscarCep(),
                            icon: _carregandoCep
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                    ),
                                )
                                : const Icon(Icons.search),
                            label: Text(
                                _carregandoCep
                                    ? 'Consultando...'
                                    : 'Consultar CEP',
                            ),
                        ),
                        if (_erroCep != null) ...[
                            const SizedBox(height: 12),
                            Text(
                                _erroCep!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.red,
                                ),
                            ),
                        ],
                        const SizedBox(height: 16),
                        _cardEndereco(),
                        _cardCotacao(),
                        _cardHistorico(),
                    ],
                ),
            ),
        );
    }
}

