// imports nativos do flutter
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import das telas
import 'package:orgalive/screens/releases/widgets/body_future_releases.dart';

// import dos modelos
import 'package:orgalive/model/core/firebase/model_firebase.dart';

class FutureReleases extends StatefulWidget {
  const FutureReleases({Key? key}) : super(key: key);

  @override
  _FutureReleasesState createState() => _FutureReleasesState();
}

class _FutureReleasesState extends State<FutureReleases> {

  // variaveis da tela
  String _userUid = "";

  // exibir tabs na tela
  TabController ?_tabController;

  // abas de lancamento
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

  // buscar as informacoes do usuario
  _getInfos() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? userData = auth.currentUser;

    _userUid = userData!.uid;

  }

  @override
  void initState() {
    super.initState();
    Analytics().sendScreen("future-releases");
    _getInfos();
  }

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
          children: [

            // despesa
            Scaffold(
              body: BodyFutureReleases( screenActive: 1, userUid: _userUid, ),
            ),

            // lucro
            Scaffold(
              body: BodyFutureReleases( screenActive: 2, userUid: _userUid, ),
            ),

            // transferencia
            Scaffold(
              body: BodyFutureReleases( screenActive: 3, userUid: _userUid, ),
            ),

          ],
        ),
      ),
    );
  }
}
