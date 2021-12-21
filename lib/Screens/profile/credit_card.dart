// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import dos modelos
import 'package:orgalive/Model/Core/firebase/model_firebase.dart';
import 'package:orgalive/Model/Core/styles/orgalive_colors.dart';
import 'package:orgalive/Model/model_credit_card.dart';

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

  // buscar contas
  Future<List<ModelCreditCard>> _getCards() async {

    if ( _listCards.isEmpty ) {

      var data = await _db.collection("credit_card").get();

      List<ModelCreditCard> list = [];

      for ( var item in data.docs ) {

        ModelCreditCard modelCreditCard = ModelCreditCard(
          item["type"],
          item["number"],
          item["valid"],
          item["cvv"],
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cartões de crédito"),
      ),

      body: RefreshIndicator(
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

                return Card(
                  color: OrgaliveColors.greyDefault,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular( 10 ),
                  ),
                  child: ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.solidCreditCard,
                      color: OrgaliveColors.darkGray,
                      size: 25,
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
                );

              },
            );
          },
        )
      )
    );
  }
}
