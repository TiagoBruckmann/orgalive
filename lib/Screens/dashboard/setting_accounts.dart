// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import dos modelos
import 'package:orgalive/Model/Core/orgalive_colors.dart';

class SettingAccounts extends StatefulWidget {

  final double value;
  const SettingAccounts({Key? key, required this.value}) : super(key: key);

  @override
  _SettingAccountsState createState() => _SettingAccountsState();
}

class _SettingAccountsState extends State<SettingAccounts> {

  String? _value;

  // nova conta
  _newAccount() {

  }

  // editar a conta
  _editAccount() {

  }

  // atualizar conta
  _editValue() {

    // configurar o valor da conta
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
                          setState(() {
                            _value = _controllerValue.text.trim().replaceAll("R\$ ", "");
                          });
                          _updateVale( _controllerValue.text.trim().replaceAll("R\$ ", "") );
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
          );
        }
    );
  }

  _updateVale(String value) {

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

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
        child: Column(
          children: [

            const Text(
              "Aqui estão as suas contas. Você pode editá-las e ajustar seu saldo caso haja a necessidade.",
              style: TextStyle(
                color: OrgaliveColors.silver,
                fontSize: 14,
              ),
            ),

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
                      title: const Text(
                        "Conta inicial",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          const Text(
                            "Outros",
                            style: TextStyle(
                              color: OrgaliveColors.silver,
                              fontSize: 15,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              _editAccount();
                            },
                            child: const FaIcon(
                              FontAwesomeIcons.chevronRight,
                              color: OrgaliveColors.silver,
                              size: 16,
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
                                ( _value == null )
                                ? "R\$ ${widget.value}"
                                : "R\$ $_value",
                                style: const TextStyle(
                                  color: OrgaliveColors.blueDefault,
                                  fontSize: 15,
                                ),
                              ),

                            ],
                          ),

                          GestureDetector(
                            onTap: () {
                              _editValue();
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
      ),
    );
  }
}
