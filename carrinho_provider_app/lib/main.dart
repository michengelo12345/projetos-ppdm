import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/produto.dart';
import 'providers/carrinho_provider.dart';


void main() {

    runApp(
        ChangeNotifierProvider(
            create: (context) => CarrinhoProvider(),
            child: const CarrinhoApp(),
        ),
    );

}


class CarrinhoApp extends StatelessWidget {

    const CarrinhoApp({super.key});


    @override
    Widget build(BuildContext context) {

        return MaterialApp(
            title: 'Carrinho com Provider',

            debugShowCheckedModeBanner: false,

            theme: ThemeData(
                primarySwatch: Colors.teal,
                useMaterial3: true,
            ),

            home: const CatalogoScreen(),
        );

    }

}


// =============================
// TELA DO CATÁLOGO
// =============================

class CatalogoScreen extends StatelessWidget {

    const CatalogoScreen({super.key});


    final List<Produto> produtos = const [

        Produto(
            id: '1',
            nome: 'Teclado Mecânico',
            preco: 250.00,
        ),

        Produto(
            id: '2',
            nome: 'Mouse Gamer',
            preco: 120.00,
        ),

        Produto(
            id: '3',
            nome: 'Monitor 24"',
            preco: 890.00,
        ),

        Produto(
            id: '4',
            nome: 'Headset Stereo',
            preco: 180.00,
        ),

    ];


    @override
    Widget build(BuildContext context) {

        return Scaffold(

            appBar: AppBar(

                title: const Text(
                    'Catálogo de Produtos',
                ),

                backgroundColor: Colors.teal,

                foregroundColor: Colors.white,

                centerTitle: true,


                actions: [

                    Stack(

                        alignment: Alignment.center,

                        children: [

                            IconButton(

                                icon: const Icon(
                                    Icons.shopping_cart,
                                ),

                                onPressed: () {

                                    Navigator.push(

                                        context,

                                        MaterialPageRoute(

                                            builder: (context) =>
                                                const CarrinhoScreen(),

                                        ),

                                    );

                                },

                            ),


                            Positioned(

                                right: 8,

                                top: 8,


                                child: Consumer<CarrinhoProvider>(

                                    builder: (
                                        context,
                                        carrinho,
                                        child,
                                    ) {


                                        if (carrinho.quantidade == 0) {

                                            return const SizedBox();

                                        }


                                        return CircleAvatar(

                                            radius: 10,

                                            backgroundColor:
                                                Colors.red,


                                            child: Text(

                                                '${carrinho.quantidade}',

                                                style: const TextStyle(

                                                    fontSize: 12,

                                                    color:
                                                        Colors.white,

                                                ),

                                            ),

                                        );


                                    },

                                ),

                            ),

                        ],

                    ),

                ],

            ),



            body: ListView.builder(

                itemCount: produtos.length,


                itemBuilder: (context, index) {


                    final produto = produtos[index];


                    return Card(

                        margin: const EdgeInsets.symmetric(

                            horizontal: 12,

                            vertical: 6,

                        ),


                        child: ListTile(

                            title: Text(

                                produto.nome,

                                style: const TextStyle(

                                    fontWeight:
                                        FontWeight.bold,

                                ),

                            ),


                            subtitle: Text(

                                'R\$ ${produto.preco.toStringAsFixed(2)}',

                            ),



                            trailing:
                                Consumer<CarrinhoProvider>(

                                    builder: (

                                        context,

                                        carrinho,

                                        child,

                                    ) {


                                        final adicionado =
                                            carrinho.itens.contains(
                                                produto,
                                            );



                                        return IconButton(

                                            icon: Icon(

                                                adicionado

                                                    ? Icons.check_circle

                                                    : Icons
                                                        .add_shopping_cart,


                                                color: adicionado

                                                    ? Colors.green

                                                    : Colors.teal,

                                            ),



                                            onPressed: () {


                                                if (!adicionado) {


                                                    carrinho.adicionar(
                                                        produto,
                                                    );


                                                }


                                            },

                                        );


                                    },

                                ),

                        ),

                    );

                },

            ),

        );

    }

}



// =============================
// TELA DO CARRINHO
// =============================

class CarrinhoScreen extends StatelessWidget {

    const CarrinhoScreen({super.key});


    @override
    Widget build(BuildContext context) {


        return Scaffold(


            appBar: AppBar(

                title: const Text(
                    'Seu Carrinho',
                ),

                backgroundColor: Colors.teal,

                foregroundColor: Colors.white,

            ),



            body: Consumer<CarrinhoProvider>(


                builder: (
                    context,
                    carrinho,
                    child,
                ) {


                    if (carrinho.quantidade == 0) {


                        return const Center(

                            child: Text(

                                'Seu carrinho está vazio!',

                                style: TextStyle(

                                    fontSize: 18,

                                ),

                            ),

                        );


                    }



                    return Column(


                        children: [



                            Expanded(


                                child: ListView.builder(


                                    itemCount:
                                        carrinho.itens.length,



                                    itemBuilder: (
                                        context,
                                        index,
                                    ) {


                                        final produto =
                                            carrinho.itens[index];



                                        return ListTile(


                                            title: Text(
                                                produto.nome,
                                            ),



                                            subtitle: Text(

                                                'R\$ ${produto.preco.toStringAsFixed(2)}',

                                            ),



                                            trailing:
                                                IconButton(


                                                    icon: const Icon(

                                                        Icons
                                                            .remove_circle_outline,

                                                        color:
                                                            Colors.red,

                                                    ),



                                                    onPressed: () {


                                                        carrinho.remover(
                                                            produto,
                                                        );


                                                    },

                                                ),


                                        );


                                    },


                                ),


                            ),





                            Container(


                                padding:
                                    const EdgeInsets.all(20),



                                color:
                                    Colors.teal.shade50,



                                child: Row(


                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,



                                    children: [



                                        Text(


                                            'Total: R\$ ${carrinho.valorTotal.toStringAsFixed(2)}',



                                            style:
                                                const TextStyle(


                                                    fontSize: 20,


                                                    fontWeight:
                                                        FontWeight.bold,


                                                ),


                                        ),





                                        ElevatedButton(



                                            onPressed: () {


                                                carrinho.limpar();



                                                ScaffoldMessenger.of(
                                                    context,
                                                ).showSnackBar(


                                                    const SnackBar(

                                                        content: Text(

                                                            'Compra finalizada com sucesso!',

                                                        ),

                                                    ),


                                                );


                                            },



                                            style: ElevatedButton
                                                .styleFrom(


                                                    backgroundColor:
                                                        Colors.teal,


                                                    foregroundColor:
                                                        Colors.white,


                                                ),



                                            child: const Text(

                                                'Finalizar',

                                            ),



                                        ),



                                    ],


                                ),


                            ),



                        ],


                    );


                },


            ),


        );


    }

}
