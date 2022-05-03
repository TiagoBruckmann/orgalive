// imports nativos do flutter
import 'package:flutter/material.dart';
import 'dart:async';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

// import dos modelos
import 'package:orgalive/core/firebase/model_firebase.dart';
import 'package:orgalive/core/styles/orgalive_colors.dart';
import 'package:orgalive/core/routes/shared_routes.dart';
import 'package:orgalive/model/model_categories.dart';

// import das telas
import 'package:orgalive/screens/widgets/loading_connection.dart';

// gerenciadores de estado
import 'package:orgalive/mobx/connection/connection_mobx.dart';
import 'package:orgalive/blocs/spendings/spending_blocs.dart';

class SpendingLimits extends StatefulWidget {
  const SpendingLimits({ Key? key }) : super(key: key);

  @override
  _SpendingLimitsState createState() => _SpendingLimitsState();
}

class _SpendingLimitsState extends State<SpendingLimits> {

  // gerenciadores de estado
  final SpendingBloc _bloc = SpendingBloc();
  late ConnectionMobx _connectionMobx;

  // recarregamento da tela
  _refresh() async {

    await Future.delayed(const Duration(seconds: 0, milliseconds: 200));

    if ( _bloc.isLoading == false ) {
      _bloc.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    Analytics().sendScreen("spending-limits");
    _bloc.getCategories();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    _connectionMobx = Provider.of<ConnectionMobx>(context);
    await _connectionMobx.verifyConnection();
    _connectionMobx.connectivity.onConnectivityChanged.listen(_connectionMobx.updateConnectionStatus);

  }

  @override
  void dispose() {
    super.dispose();
    _bloc.closeStream();
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
                    SharedRoutes().goToNewSpending(context);
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
            child: StreamBuilder(
              stream: _bloc.listen,
              builder: ( context, snapshot ) {

                // verificando conexão
                if ( _bloc.listCategories.isNotEmpty ) {

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

                  } else if ( _bloc.listCategories.isEmpty ) {

                    if ( _bloc.isLoading == true ) {

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

                  }  else if ( _bloc.listCategories == [] ) {

                    if ( _bloc.isLoading == true ) {

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
                  itemCount: _bloc.listCategories.length,
                  itemBuilder: ( context, index ) {

                    ModelCategories modelCategories = _bloc.listCategories[index];

                    return Container(
                      padding: const EdgeInsets.fromLTRB(2, 10, 2, 0),
                      child: Row(
                        children: [

                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                SharedRoutes().goToDetailSpending(context, modelCategories);
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
                                        leading: Text(
                                          modelCategories.name,
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
                                        children: [

                                          Padding(
                                            padding: const EdgeInsets.symmetric( horizontal: 10, vertical: 10 ),
                                            child: Text.rich(
                                              TextSpan(
                                                text: "R\$ ${modelCategories.valueSpending}",
                                                style: const TextStyle(
                                                  color: OrgaliveColors.whiteSmoke,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: "/R\$ ${modelCategories.valueLimit}",
                                                    style: const TextStyle(
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