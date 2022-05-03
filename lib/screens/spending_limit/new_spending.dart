// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

// import dos modelos
import 'package:orgalive/core/functions/shared/shared_functions.dart';
import 'package:orgalive/core/firebase/model_firebase.dart';
import 'package:orgalive/core/styles/orgalive_colors.dart';
import 'package:orgalive/core/routes/shared_routes.dart';

// import das telas
import 'package:orgalive/screens/widgets/loading_connection.dart';
import 'package:orgalive/screens/widgets/message_widget.dart';

// gerenciadores de estado
import 'package:orgalive/mobx/connection/connection_mobx.dart';

class NewSpending extends StatefulWidget {
  const NewSpending({ Key? key }) : super(key: key);

  @override
  _NewSpendingState createState() => _NewSpendingState();
}

class _NewSpendingState extends State<NewSpending> {

  // controladores
  final TextEditingController _controllerName = TextEditingController();
  final MoneyMaskedTextController _controllerLimit = MoneyMaskedTextController( leftSymbol: 'R\$ ', thousandSeparator: '.', decimalSeparator: ',' );
  final MoneyMaskedTextController _controllerSpending = MoneyMaskedTextController( leftSymbol: 'R\$ ', thousandSeparator: '.', decimalSeparator: ',' );

  bool _selected = false;

  // gerenciadores de estado
  late ConnectionMobx _connectionMobx;

  // validar gasto / categoria
  _validateSpending() {

    if ( _controllerName.text.isEmpty ) {
      CustomSnackBar( context, "Informe o nome da categoria", OrgaliveColors.redDefault );
    } else if ( _controllerLimit.text == "R\$ 0,00" ) {
      CustomSnackBar( context, "Informe um gasto limite mensal para a categoria", OrgaliveColors.redDefault );
    } else {
      _createSpending();
    }
  }

  // criar categoria
  _createSpending() async {

    final FirebaseFirestore _db = FirebaseFirestore.instance;

    String uid = SharedFunctions().getRandomString(20);
    String valueLimit = _controllerLimit.text.replaceAll("R\$", "").replaceAll(".", "").replaceAll(",", ".");
    String valueSpending = _controllerSpending.text.replaceAll("R\$", "").replaceAll(".", "").replaceAll(",", ".");

    double percentage = 0;
    if ( _controllerSpending.text != "R\$ 0,00" ) {
      double calc1 = double.parse(valueLimit) - double.parse(valueSpending);
      percentage = calc1 / double.parse(valueLimit);
    }

    dynamic data = {
      "name": _controllerName.text,
      "percentage": percentage,
      "selected": _selected,
      "uid": uid,
      "value_limit": valueLimit,
      "value_spending": valueSpending,
    };

    await _db.collection("categories").doc(uid).set(data)
      .then((value) {

        CustomSnackBar(context, "Categoria cadastrada com sucesso!", Colors.red);
        SharedRoutes().goToHomeRemoveUntil(context);

      }).catchError((error) {
        FirebaseCrashlytics.instance.log(error.toString());
        CustomSnackBar(context, "Não foi possível cadastrar a categoria.", Colors.red);
      });

  }

  @override
  void initState() {
    super.initState();
    Analytics().sendScreen("new_spending");
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
            title: const Text("Nova categoria"),
          ),

          body: ( _connectionMobx.connectionStatus.toString() == "ConnectivityResult.none" )
          ? const LoadingConnection()
          : SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 5),
            child: Column(
              children: [

                // nome da categoria
                Padding(
                  padding: const EdgeInsets.only( bottom: 20 ),
                  child: TextField(
                    controller: _controllerName,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(
                      color: OrgaliveColors.silver,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
                      labelText: "Nome",
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

                // limite de gasto
                Padding(
                  padding: const EdgeInsets.only( bottom: 20 ),
                  child: TextField(
                    controller: _controllerLimit,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(
                      color: OrgaliveColors.silver,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
                      labelText: "Limite mensal",
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

                // valor gasto
                Padding(
                  padding: const EdgeInsets.only( bottom: 20 ),
                  child: TextField(
                    controller: _controllerSpending,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(
                      color: OrgaliveColors.silver,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
                      labelText: "Valor gasto",
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

                SwitchListTile(
                  title: const Text(
                    "Gasto essencial?",
                    style: TextStyle(
                      color: OrgaliveColors.silver,
                      fontSize: 20,
                    ),
                  ),
                  value: _selected,
                  activeColor: OrgaliveColors.silver,
                  tileColor: Theme.of(context).scaffoldBackgroundColor,
                  onChanged: (value) {
                    setState(() {
                      _selected = !_selected;
                    });
                  },
                ),

                Padding(
                  padding: const EdgeInsets.only( top: 25 ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: OrgaliveColors.greenDefault,
                      padding: const EdgeInsets.symmetric( vertical: 17, horizontal: 80 ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _validateSpending();
                    },
                    child: const Text(
                      "Cadastrar categoria",
                      style: TextStyle(
                        color: OrgaliveColors.whiteSmoke,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
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
