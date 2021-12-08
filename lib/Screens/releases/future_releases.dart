// imports nativos do flutter
import 'package:flutter/material.dart';

// import das telas
import 'package:orgalive/Screens/releases/widgets/body_future_releases.dart';

class FutureReleases extends StatefulWidget {
  const FutureReleases({Key? key}) : super(key: key);

  @override
  _FutureReleasesState createState() => _FutureReleasesState();
}

class _FutureReleasesState extends State<FutureReleases> {

  // exibir tabs na tela
  TabController ?_tabController;

  final List<Tab> _tabs = <Tab>[
    // despesas
    Tab(
      child: Row(
        children: const [
          Text("Despesa"),
        ],
      ),
    ),

    // receita
    Tab(
      child: Row(
        children: const [
          Padding(
            padding: EdgeInsets.only(left: 5),
          ),
          Text("Receita"),
        ],
      ),
    ),

    // transferencia
    Tab(
      child: Row(
        children: const [
          Padding(
            padding: EdgeInsets.only(left: 5),
          ),
          Text("Transferência"),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Lançamentos futuros"),

          // tabs de exibição dos status do pedido
          bottom: TabBar(
            indicatorWeight: 4,
            isScrollable: true,
            labelStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            controller: _tabController,
            indicatorColor: Theme.of(context).secondaryHeaderColor,
            tabs: _tabs,
          ),

        ),

        body: TabBarView(
          controller: _tabController,
          children: const [

            // despesa
            Scaffold(
              body: BodyFutureReleases( screenActive: 1, ),
            ),

            // lucro
            Scaffold(
              body: BodyFutureReleases( screenActive: 2, ),
            ),

            // transferencia
            Scaffold(
              body: BodyFutureReleases( screenActive: 3, ),
            ),

          ],
        ),
      ),
    );
  }
}
