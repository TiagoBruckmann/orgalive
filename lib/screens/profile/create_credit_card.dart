// pacotes nativos flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// import dos modelos
import 'package:orgalive/core/styles/orgalive_colors.dart';

// import das telas
import 'package:orgalive/screens/widgets/loading_connection.dart';
import 'package:orgalive/screens/widgets/message_widget.dart';

// gerenciadores de estado
import 'package:orgalive/mobx/connection/connection_mobx.dart';

class CreateCreditCard extends StatefulWidget {

  final String userUid;
  const CreateCreditCard({ Key? key, required this.userUid }) : super(key: key);

  @override
  _CreateCreditCardState createState() => _CreateCreditCardState();
}

class _CreateCreditCardState extends State<CreateCreditCard> {

  // gerenciadores de estado
  late ConnectionMobx _connectionMobx;

  // controladores de texto
  final MaskedTextController _controllerCardNumber = MaskedTextController( mask: "0000 **** **** 0000" );
  final MaskedTextController _controllerValid = MaskedTextController( mask: "00/00" );
  final MaskedTextController _controllerCvv = MaskedTextController( mask: "000" );

  // variaveis da tela
  var _icon = FontAwesomeIcons.creditCard;
  String _brand = "";

  // validar o cartao
  _validateCard() {

    if ( _controllerCardNumber.text.isEmpty || _controllerCardNumber.text.length != 19 ) {

      CustomSnackBar(
        context,
        "Insira um cartão de credito válido.",
        OrgaliveColors.redDefault,
      );

    } else if ( _controllerValid.text.isEmpty || _controllerValid.text.length != 5 ) {

      CustomSnackBar(
        context,
        "Insira uma data de vencimento válida.",
        OrgaliveColors.redDefault,
      );

    } else if ( _controllerCvv.text.isEmpty || _controllerCvv.text.length != 3 ) {

      CustomSnackBar(
        context,
        "Insira um código de verificação válido",
        OrgaliveColors.redDefault,
      );

    } else {
      _createCard();
    }
  }

  _createCard() async {

    DateTime now = DateTime.now();
    String dateNow = DateFormat('yyyyMMddkkmmss').format(now);

    //Salvar dados do usuário
    FirebaseFirestore db = FirebaseFirestore.instance;

    String prefix = _controllerCardNumber.text.substring(0, 4);
    String sufix = _controllerCardNumber.text.substring(15);
    String mask = _controllerCardNumber.text.substring(5, 15).replaceRange(0, 10, "**** ****");

    var data = {
      "type": _brand,
      "number": "$prefix $mask $sufix",
      "valid": _controllerValid.text,
      "cvv": _controllerCvv.text,
      "user_uid": widget.userUid,
      "document": dateNow
    };

    db.collection("credit_card").doc(dateNow).set(data);

    CustomSnackBar(
      context,
      "Cartão cadastrado com sucesso!",
      OrgaliveColors.greenDefault,
    );
    Navigator.pop(context);
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
            title: const Text("Cartão"),
          ),

          body: ( _connectionMobx.connectionStatus.toString() == "ConnectivityResult.none" )
          ? const LoadingConnection()
          : SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 5),
            child: Column(
              children: [

                // numero do cartao
                Padding(
                  padding: const EdgeInsets.only( bottom: 20 ),
                  child: TextField(
                    controller: _controllerCardNumber,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(
                      color: OrgaliveColors.silver,
                      fontSize: 20,
                    ),
                    onChanged: ( value ) {
                      if ( value.length == 2 ) {
                        String credit = value.substring(0, 2);
                        int type = int.parse(credit);
                        if ( type >= 40 && type <= 50 ) {
                          setState(() {
                            _brand = "Visa";
                            _icon = FontAwesomeIcons.ccVisa;
                          });
                        } else if ( type >= 50 && type <= 63 ) {
                          setState(() {
                            _brand = "Master";
                            _icon = FontAwesomeIcons.ccMastercard;
                          });
                        } else {
                          setState(() {
                            _brand = "another";
                            _icon = FontAwesomeIcons.creditCard;
                          });
                        }
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
                      labelText: "Cartão",
                      filled: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only( top: 10, left: 10 ),
                        child: FaIcon(
                          _icon,
                          color: OrgaliveColors.whiteSmoke,
                        ),
                      ),
                      labelStyle: const TextStyle(
                        color: OrgaliveColors.silver,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: OrgaliveColors.silver,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: OrgaliveColors.silver,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),

                // cvv e validade
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: TextField(
                        controller: _controllerValid,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(
                          color: OrgaliveColors.silver,
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
                          labelText: "Validade",
                          filled: true,
                          labelStyle: const TextStyle(
                            color: OrgaliveColors.silver,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: OrgaliveColors.silver,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: OrgaliveColors.silver,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: TextField(
                        controller: _controllerCvv,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        style: const TextStyle(
                          color: OrgaliveColors.silver,
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
                          labelText: "CVV",
                          filled: true,
                          labelStyle: const TextStyle(
                            color: OrgaliveColors.silver,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: OrgaliveColors.silver,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: OrgaliveColors.silver,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only( top: 20 ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: OrgaliveColors.greenDefault,
                      padding: const EdgeInsets.symmetric( horizontal: 20, vertical: 17 ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      _validateCard();
                    },
                    child: const Text(
                      "Cadastrar cartão",
                      style: TextStyle(
                        color: OrgaliveColors.greyDefault,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        );

      },
    );
  }
}
