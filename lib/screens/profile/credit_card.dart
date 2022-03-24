// imports nativos do flutter
import 'package:flutter/material.dart';
import 'dart:async';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

// import dos modelos
import 'package:orgalive/model/core/firebase/model_firebase.dart';
import 'package:orgalive/model/core/styles/orgalive_colors.dart';
import 'package:orgalive/model/model_credit_card.dart';

// import das telas
import 'package:orgalive/screens/widgets/loading_connection.dart';
import 'package:orgalive/screens/profile/create_credit_card.dart';

// gerenciadores de estado
import 'package:orgalive/mobx/connection/connection_mobx.dart';

class CreditCard extends StatefulWidget {

  final String userUid;
  const CreditCard({ Key? key, required this.userUid }) : super(key: key);

  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {

  // variavies da tela
  final List<ModelCreditCard> _listCards = [];
  bool _isLoading =  true;

  // variaveis do banco
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // gerenciadores de estado
  late ConnectionMobx _connectionMobx;

  // buscar contas
  Future<List<ModelCreditCard>> _getCards() async {

    if ( _listCards.isEmpty && _isLoading == true ) {

      var data = await _db.collection("credit_card")
        .where("user_uid", isEqualTo: widget.userUid)
        .get();

      List<ModelCreditCard> list = [];

      for ( var item in data.docs ) {

        ModelCreditCard modelCreditCard = ModelCreditCard(
          item["type"],
          item["number"],
          item["valid"],
          item["cvv"],
          item["user_uid"],
          item["document"]
        );

        list.add(modelCreditCard);
      }

      setState(() {
        _listCards.addAll(list);
        _isLoading = false;
      });

    }

    return _listCards;
  }

  _newCreditCard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => CreateCreditCard(
          userUid: widget.userUid,
        ),
      ),
    ).then( _onGoBack );
  }

  // forca o recarregamento ao voltar para essa tela
  FutureOr _onGoBack( dynamic value ) {
    setState(() {
      _refresh();
    });
  }

  // recarregamento da tela
  _refresh() async {

    await Future.delayed(const Duration(seconds: 0, milliseconds: 200));

    if ( _isLoading == false ) {

      setState(() {
        _isLoading = true;
        _listCards.clear();
      });

    }
  }

  @override
  void initState() {
    super.initState();
    Analytics().sendScreen("credit-card");
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

                const Text("Cartões de credito"),

                // novo cartao
                GestureDetector(
                  onTap: () {
                    _newCreditCard();
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
            child: FutureBuilder<List<ModelCreditCard>>(
              future: _getCards(),
              builder: ( context, snapshot ) {

                // verificando conexão
                if ( _listCards.isNotEmpty ) {

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

                  } else if ( _listCards.isEmpty ) {

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

                  }  else if ( _listCards == [] ) {

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
                  itemCount: _listCards.length,
                  itemBuilder: ( context, index ) {

                    ModelCreditCard modelCreditCard = _listCards[index];

                    return Padding(
                      padding: const EdgeInsets.only( top: 6 ),
                      child: Card(
                        color: OrgaliveColors.greyDefault,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular( 10 ),
                        ),
                        child: ListTile(
                          leading: FaIcon(
                            ( modelCreditCard.type == "Master" )
                            ? FontAwesomeIcons.ccMastercard
                            : ( modelCreditCard.type == "Visa" )
                            ? FontAwesomeIcons.ccVisa
                            : FontAwesomeIcons.solidCreditCard,
                            color: OrgaliveColors.darkGray,
                            size: 30,
                          ),
                          title: Text(
                            "${modelCreditCard.number}",
                            style: const TextStyle(
                              color: OrgaliveColors.whiteSmoke,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Text.rich(
                                TextSpan(
                                  text: "Validade: ",
                                  style: const TextStyle(
                                    color: OrgaliveColors.silver,
                                    fontSize: 15,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "${modelCreditCard.valid}",
                                      style: const TextStyle(
                                        color: OrgaliveColors.whiteSmoke,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Text.rich(
                                TextSpan(
                                  text: "CVV: ",
                                  style: const TextStyle(
                                    color: OrgaliveColors.silver,
                                    fontSize: 15,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "${modelCreditCard.cvv}",
                                      style: const TextStyle(
                                        color: OrgaliveColors.whiteSmoke,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
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
