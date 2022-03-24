// imports nativos do flutter
import 'package:flutter/material.dart';
import 'dart:async';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

// import dos modelos
import 'package:orgalive/model/core/firebase/model_firebase.dart';
import 'package:orgalive/model/core/styles/orgalive_colors.dart';
import 'package:orgalive/model/model_categories.dart';

// import das telas
import 'package:orgalive/screens/spending_limit/detail_spending.dart';
import 'package:orgalive/screens/spending_limit/new_spending.dart';
import 'package:orgalive/screens/widgets/loading_connection.dart';

// gerenciadores de estado
import 'package:orgalive/mobx/connection/connection_mobx.dart';

class SpendingLimits extends StatefulWidget {
  const SpendingLimits({ Key? key }) : super(key: key);

  @override
  _SpendingLimitsState createState() => _SpendingLimitsState();
}

class _SpendingLimitsState extends State<SpendingLimits> {

  // variaveis da tela
  final List<ModelCategories> _listCategories = [];
  bool _isLoading =  true;
  String _userUid = "";

  // variaveis do banco
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // gerenciadores de estado
  late ConnectionMobx _connectionMobx;

  // buscar informacoes
  _getInfos() {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? userData = auth.currentUser;

    _userUid = userData!.uid;
  }

  // buscar categorias
  Future<List<ModelCategories>> _getCategories() async {

    if ( _listCategories.isEmpty && _isLoading == true ) {

      var data = await _db.collection("categories")
          .get();

      List<ModelCategories> list = [];

      for ( var item in data.docs ) {

        ModelCategories modelCategories = ModelCategories(
          item["uid"],
          item["icon"],
          item["name"],
          /*
          item["selected"],
          item["value_spending"],
          item["value_limit"],
          */
        );

        list.add(modelCategories);
      }

      setState(() {
        _listCategories.addAll(list);
        _isLoading = false;
      });

    }

    return _listCategories;
  }

  // forca o recarregamento ao voltar para essa tela
  FutureOr _onGoBack( dynamic value ) {
    setState(() {
      _refresh();
    });
  }

  // novo limite
  _newSpending() {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => NewSpending(
          userUid: _userUid,
        ),
      ),
    ).then(_onGoBack);
  }

  // ir para os detalhes
  _goToDetailSpending( ModelCategories modelCategories ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => DetailSpending(
          id: modelCategories.uid!,
          name: modelCategories.name!,
        ),
      ),
    );
  }

  // recarregamento da tela
  _refresh() async {

    await Future.delayed(const Duration(seconds: 0, milliseconds: 200));

    if ( _isLoading == false ) {

      setState(() {
        _isLoading = true;
        _listCategories.clear();
      });

    }
  }

  @override
  void initState() {
    super.initState();
    Analytics().sendScreen("spending-limits");
    _getInfos();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    _connectionMobx = Provider.of<ConnectionMobx>(context);

    await _connectionMobx.verifyConnection();
    _connectionMobx.connectivity.onConnectivityChanged.listen(_connectionMobx.updateConnectionStatus);

  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (builder) {

        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                const Text("Limite de gastos"),

                GestureDetector(
                  onTap: () {
                    _newSpending();
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.plus,
                  ),
                ),

              ],
            ),
          ),
          body: ( _connectionMobx.connectionStatus.toString() == "ConnectivityResult.none" )
          ? const LoadingConnection()
          : RefreshIndicator(
            onRefresh: () {
              return _refresh();
            },
            child: FutureBuilder<List<ModelCategories>>(
              future: _getCategories(),
              builder: ( context, snapshot ) {

                // verificando conexão
                if ( _listCategories.isNotEmpty ) {

                } else {
                  if ( snapshot.hasError ) {

                    return RefreshIndicator(
                      onRefresh: () {
                        return _refresh();
                      },
                      child: const CircularProgressIndicator(
                        color: OrgaliveColors.darkGray,
                      ),
                    );

                  } else if ( snapshot.connectionState == ConnectionState.waiting ) {

                    return const CircularProgressIndicator(
                      color: OrgaliveColors.darkGray,
                    );

                  } else if ( _listCategories.isEmpty ) {

                    if ( _isLoading == true ) {

                      return const CircularProgressIndicator(
                        color: OrgaliveColors.darkGray,
                      );

                    } else {

                      return RefreshIndicator(
                        onRefresh: () {
                          return _refresh();
                        },
                        child: const CircularProgressIndicator(
                          color: OrgaliveColors.darkGray,
                        ),
                      );

                    }

                  }  else if ( _listCategories == [] ) {

                    if ( _isLoading == true ) {

                      return const CircularProgressIndicator(
                        color: OrgaliveColors.darkGray,
                      );

                    } else {

                      return RefreshIndicator(
                        onRefresh: () {
                          return _refresh();
                        },
                        child: const CircularProgressIndicator(
                          color: OrgaliveColors.darkGray,
                        ),
                      );

                    }

                  }
                }

                return ListView.builder(
                  itemCount: _listCategories.length,
                  itemBuilder: ( context, index ) {

                    ModelCategories modelCategories = _listCategories[index];

                    return Container(
                      padding: const EdgeInsets.fromLTRB(2, 10, 2, 0),
                      child: Row(
                        children: [

                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _goToDetailSpending( modelCategories );
                              },
                              child: Card(
                                color: OrgaliveColors.greyDefault,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular( 10 ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 10, 16, 10),
                                  child: Column(
                                    children: [

                                      // categoria
                                      ListTile(
                                        leading: const CircleAvatar(
                                          backgroundColor: OrgaliveColors.darkGray,
                                          radius: 17,
                                          child: FaIcon(
                                            FontAwesomeIcons.house,
                                            color: OrgaliveColors.bossanova,
                                            size: 14,
                                          ),
                                        ),
                                        title: Text(
                                          "${modelCategories.name}",
                                          style: const TextStyle(
                                            color: OrgaliveColors.whiteSmoke,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),

                                      const Divider(
                                        color: OrgaliveColors.bossanova,
                                        height: 5,
                                        indent: 10,
                                        endIndent: 10,
                                      ),

                                      // quantidade gasta
                                      Row(
                                        children: const [

                                          Padding(
                                            padding: EdgeInsets.only( left: 10, top: 10 ),
                                            child: Text(
                                              "Disponível",
                                              style: TextStyle(
                                                color: OrgaliveColors.silver,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: const [

                                          Padding(
                                            padding: EdgeInsets.symmetric( horizontal: 10, vertical: 10 ),
                                            child: Text.rich(
                                              TextSpan(
                                                text: "R\$ 0,00",
                                                style: TextStyle(
                                                  color: OrgaliveColors.whiteSmoke,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: "/R\$ 300,00",
                                                    style: TextStyle(
                                                      color: OrgaliveColors.silver,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),

                                      const Divider(
                                        color: OrgaliveColors.bossanova,
                                        height: 10,
                                        indent: 10,
                                        endIndent: 10,
                                      ),

                                      // cartao e porcentagem gasta
                                      Row(
                                        children: [

                                          Card(
                                            color: Colors.greenAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular( 4 ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric( vertical: 5, horizontal: 10 ),
                                              child: Row(
                                                children: const [

                                                  FaIcon(
                                                    FontAwesomeIcons.caretDown,
                                                    color: OrgaliveColors.greenDefault,
                                                    size: 15,
                                                  ),

                                                  Padding(
                                                    padding: EdgeInsets.only( left: 5 ),
                                                    child: Text(
                                                      "0.00%",
                                                      style: TextStyle(
                                                        color: OrgaliveColors.greenDefault,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),

                                          const Text(
                                            "Comparado ao mês anterior",
                                            style: TextStyle(
                                              color: OrgaliveColors.whiteSmoke,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            ),
                                          ),

                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          /*
                          // lista vertical que fica na lateral direita
                          const VerticalDivider(
                            indent: 10,
                            endIndent: 10,
                            color: OrgaliveColors.yellowDefault,
                            // thickness: 15,
                            width: 25,
                          ),
                          */

                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );

      },
    );
  }
}