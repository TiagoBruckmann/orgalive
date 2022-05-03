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
import 'package:orgalive/model/model_credit_card.dart';

// import das telas
import 'package:orgalive/screens/widgets/loading_connection.dart';

// gerenciadores de estado
import 'package:orgalive/blocs/credit_card/credit_card_bloc.dart';
import 'package:orgalive/mobx/connection/connection_mobx.dart';
import 'package:orgalive/mobx/users/users_mobx.dart';

class CreditCard extends StatefulWidget {
  const CreditCard({ Key? key }) : super(key: key);

  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {

  // gerenciadores de estado
  final CreditCardBloc _bloc = CreditCardBloc();
  late ConnectionMobx _connectionMobx;
  late UsersMobx _usersMobx;

  // recarregamento da tela
  _refresh() async {

    await Future.delayed(const Duration(seconds: 0, milliseconds: 200));

    if ( _bloc.isLoading == false ) {
      _bloc.clear();
      _bloc.getCards(_usersMobx.userUid);
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

    _usersMobx = Provider.of<UsersMobx>(context);
    _bloc.getCards( _usersMobx.userUid );

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

                const Text("Cartões de credito"),

                // novo cartao
                GestureDetector(
                  onTap: () {
                    SharedRoutes().goToNewCreditCard(context);
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
                if ( _bloc.listCredits.isNotEmpty ) {

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

                  } else if ( _bloc.listCredits.isEmpty ) {

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

                  }  else if ( _bloc.listCredits == [] ) {

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
                  itemCount: _bloc.listCredits.length,
                  itemBuilder: ( context, index ) {

                    ModelCreditCard modelCreditCard = _bloc.listCredits[index];

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
