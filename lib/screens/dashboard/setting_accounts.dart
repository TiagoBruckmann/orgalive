// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// import dos modelos
import 'package:orgalive/model/core/firebase/model_firebase.dart';
import 'package:orgalive/model/core/styles/orgalive_colors.dart';
import 'package:orgalive/model/model_accounts.dart';

// import das telas
import 'package:orgalive/screens/widgets/message_widget.dart';

class SettingAccounts extends StatefulWidget {

  final String userUid;
  final double value;
  const SettingAccounts({ Key? key, required this.userUid, required this.value }) : super(key: key);

  @override
  _SettingAccountsState createState() => _SettingAccountsState();
}

class _SettingAccountsState extends State<SettingAccounts> {

  // variavies da tela
  final List<ModelAccounts> _listAccounts = [];
  bool _isLoading =  true;

  // variaveis do banco
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // buscar contas
  Future<List<ModelAccounts>> _getAccounts() async {

    if ( _listAccounts.isEmpty ) {

      var data = await _db.collection("accounts").where("user_uid", isEqualTo: widget.userUid).get();

      List<ModelAccounts> list = [];

      for ( var item in data.docs ) {

        ModelAccounts modelAccounts = ModelAccounts(
          item["user_uid"],
          item["name"],
          item["value"],
          item["document"],
          item["default"],
        );

        list.add(modelAccounts);
      }

      setState(() {
        _listAccounts.addAll(list);
        _isLoading = false;
      });

    }

    return _listAccounts;
  }

  // nova conta
  _newAccount() {

    // controladores de texto
    final TextEditingController _controllerName = TextEditingController();
    MoneyMaskedTextController _controllerValue = MoneyMaskedTextController( leftSymbol: 'R\$ ', thousandSeparator: '.', decimalSeparator: ',', initialValue: widget.value);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (contex) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 150, 16, 0),
          child: Center(
            child: Column(
              children: [
                AlertDialog(
                  backgroundColor: OrgaliveColors.greyBackground,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [

                      Text(
                        "Nova conta",
                        style: TextStyle(
                          color: OrgaliveColors.silver,
                          fontSize: 16,
                        ),
                      ),

                    ],
                  ),
                  content: Column(
                    children: [

                      const CircleAvatar(
                        backgroundColor: OrgaliveColors.darkGray,
                        radius: 25,
                        child: Icon(
                          Icons.account_balance,
                          color: OrgaliveColors.bossanova,
                          size: 30,
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.only( top: 20, bottom: 16 ),
                        child: Text(
                          "Cadastre uma nova conta",
                          style: TextStyle(
                            color: OrgaliveColors.silver,
                            fontSize: 15,
                          ),
                        ),
                      ),

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

                      TextField(
                        controller: _controllerValue,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        style: const TextStyle(
                          color: OrgaliveColors.silver,
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
                          labelText: "Valor",
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

                    ],
                  ),

                  contentPadding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  actions: <Widget>[

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancelar",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: OrgaliveColors.whiteSmoke,
                          fontSize: 15,
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        _validateAccount( _controllerName.text, _controllerValue.text.trim().replaceAll("R\$ ", "") );
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cadastrar!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: OrgaliveColors.whiteSmoke,
                          fontSize: 15,
                        ),
                      ),
                    ),

                  ],

                ),
              ],
            ),
          ),
        );
      }
    );
  }

  // validar conta
  _validateAccount( String name, String value ) {

    if ( name.isEmpty && name.length < 3 ) {

      CustomSnackBar(
        context,
        "É necessario inserir um nome válido para a conta",
        OrgaliveColors.redDefault,
      );

    } else {
      _createAccount( name, value );
    }

  }

  // cadastrar nova conta
  _createAccount( String name, String value ) async {

    DateTime now = DateTime.now();
    String dateNow = DateFormat('yyyyMMddkkmmss').format(now);

    var data = {
      "name": name,
      "value": value.replaceAll(",", "."),
      "user_uid": widget.userUid,
      "document": dateNow,
    };
    await _db.collection("accounts").doc(dateNow).set(data);

    CustomSnackBar(
      context,
      "Conta cadastrada com sucesso",
      OrgaliveColors.greenDefault,
    );

    _refresh();

  }

  // atualizar conta
  _editValue( String value, String document ) {

    double newValue = double.parse(value.replaceAll(",", "."));
    // configurar o valor da conta
    MoneyMaskedTextController _controllerValue = MoneyMaskedTextController( leftSymbol: 'R\$ ', thousandSeparator: '.', decimalSeparator: ',', initialValue: newValue );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (contex) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 150, 16, 0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  AlertDialog(
                    backgroundColor: OrgaliveColors.greyBackground,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [

                        Text(
                          "Carteira",
                          style: TextStyle(
                            color: OrgaliveColors.silver,
                            fontSize: 16,
                          ),
                        ),

                      ],
                    ),
                    content: Column(
                      children: [

                        const CircleAvatar(
                          backgroundColor: OrgaliveColors.darkGray,
                          radius: 25,
                          child: Icon(
                            Icons.account_balance,
                            color: OrgaliveColors.bossanova,
                            size: 30,
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.only( top: 15 ),
                          child: Text(
                            "Conta inicial",
                            style: TextStyle(
                              color: OrgaliveColors.whiteSmoke,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.only( top: 20, bottom: 16 ),
                          child: Text(
                            "Defina o novo saldo da sua conta",
                            style: TextStyle(
                              color: OrgaliveColors.silver,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        TextField(
                          controller: _controllerValue,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(
                            color: OrgaliveColors.silver,
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
                            labelText: "Valor",
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

                      ],
                    ),

                    contentPadding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    actions: <Widget>[

                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancelar",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: OrgaliveColors.whiteSmoke,
                            fontSize: 15,
                          ),
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          _updateVale( _controllerValue.text.trim().replaceAll("R\$ ", ""), document );
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Atualizar!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: OrgaliveColors.whiteSmoke,
                            fontSize: 15,
                          ),
                        ),
                      ),

                    ],

                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  // atualizar o valor da cotna
  _updateVale( String value, String document ) {

    var data = {
      "value": value.replaceAll(",", ".")
    };

    _db.collection("accounts").doc(document).update(data);

    CustomSnackBar( context, "Conta atualizada com sucesso", OrgaliveColors.greenDefault );

    _refresh();

  }

  // atualizar a tela
  _refresh() async {

    await Future.delayed(const Duration(seconds: 0, milliseconds: 200));

    if ( _isLoading == false ) {

      setState(() {
        _isLoading = true;
        _listAccounts.clear();
      });

    }
  }

  @override
  void initState() {
    super.initState();
    Analytics().sendScreen("setting-accounts");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            const Text("Contas"),

            // nova conta
            GestureDetector(
              onTap: () {
                _newAccount();
              },
              child: const FaIcon(
                FontAwesomeIcons.plus,
              ),
            ),

          ],
        ),
      ),

      body: RefreshIndicator(
        onRefresh: () {
          return _refresh();
        },
        child: FutureBuilder<List<ModelAccounts>>(
          future: _getAccounts(),
          builder: ( context, snapshot ) {

            // verificando conexão
            if ( _listAccounts.isNotEmpty ) {

            } else {
              if ( snapshot.hasError ) {

                return RefreshIndicator(
                    onRefresh: () {
                      return _refresh();
                    },
                    child: const CircularProgressIndicator(
                      color: OrgaliveColors.darkGray,
                    )
                );

              } else if ( snapshot.connectionState == ConnectionState.waiting ) {

                return const CircularProgressIndicator(
                  color: OrgaliveColors.darkGray,
                );

              } else if ( _listAccounts.isEmpty ) {

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
                      )
                  );

                }

              }  else if ( _listAccounts == [] ) {

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
                      )
                  );

                }

              }
            }

            return Scrollbar(
              child: ListView.builder(
                itemCount: _listAccounts.length,
                itemBuilder: (context, index) {

                  ModelAccounts modelAccounts = _listAccounts[index];

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
                    child: Column(
                      children: [

                        ( index == 0 )
                            ? const Text(
                          "Aqui estão as suas contas. Você pode editá-las e ajustar seu saldo caso haja a necessidade.",
                          style: TextStyle(
                            color: OrgaliveColors.silver,
                            fontSize: 14,
                          ),
                        )
                            : const Padding(padding: EdgeInsets.zero),

                        Padding(
                          padding: const EdgeInsets.only( top: 10 ),
                          child: Card(
                            color: OrgaliveColors.greyDefault,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular( 10 ),
                            ),
                            child: Column(
                              children: [

                                // detalhes da conta
                                ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: OrgaliveColors.darkGray,
                                    radius: 25,
                                    child: Icon(
                                      Icons.account_balance,
                                      color: OrgaliveColors.bossanova,
                                      size: 30,
                                    ),
                                  ),
                                  title: Text(
                                    "${modelAccounts.name}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: const [

                                      Text(
                                        "Outros",
                                        style: TextStyle(
                                          color: OrgaliveColors.silver,
                                          fontSize: 15,
                                        ),
                                      ),

                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Row(
                                        children: [
                                          const Text(
                                            "Saldo atual: ",
                                            style: TextStyle(
                                              color: OrgaliveColors.silver,
                                              fontSize: 15,
                                            ),
                                          ),

                                          Text(
                                            "R\$ ${modelAccounts.value}",
                                            style: const TextStyle(
                                              color: OrgaliveColors.blueDefault,
                                              fontSize: 15,
                                            ),
                                          ),

                                        ],
                                      ),

                                      GestureDetector(
                                        onTap: () {
                                          _editValue( modelAccounts.value!, modelAccounts.document! );
                                        },
                                        child: const FaIcon(
                                          FontAwesomeIcons.edit,
                                          color: OrgaliveColors.silver,
                                          size: 20,
                                        ),
                                      ),

                                    ],
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  );
                },
              ),
            );
          },
        )
      )
    );
  }
}
