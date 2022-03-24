// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

// import dos modelos
import 'package:orgalive/model/core/list_icons.dart' as list_icons;
import 'package:orgalive/model/core/styles/orgalive_colors.dart';

// import das telas
import 'package:orgalive/screens/widgets/loading_connection.dart';
import 'package:orgalive/screens/widgets/message_widget.dart';

// gerenciadores de estado
import 'package:orgalive/mobx/connection/connection_mobx.dart';

class NewSpending extends StatefulWidget {

  final String userUid;
  const NewSpending({ Key? key, required this.userUid }) : super(key: key);

  @override
  _NewSpendingState createState() => _NewSpendingState();
}

class _NewSpendingState extends State<NewSpending> {

  // controladores
  final TextEditingController _controllerName = TextEditingController();
  final MoneyMaskedTextController _controllerLimit = MoneyMaskedTextController( leftSymbol: 'R\$ ', thousandSeparator: '.', decimalSeparator: ',' );
  final MoneyMaskedTextController _controllerSpending = MoneyMaskedTextController( leftSymbol: 'R\$ ', thousandSeparator: '.', decimalSeparator: ',' );

  // variaveis da tela
  var _icon;

  // gerenciadores de estado
  late ConnectionMobx _connectionMobx;

  // buscar as categorias
  _getCategories() {

  }

  // validar gasto / categoria
  _validateSpending() {

    if ( _controllerName.text.isEmpty ) {

      CustomSnackBar( context, "Informe o nome da despesa", OrgaliveColors.redDefault );

    } else if ( _icon == null ) {

      CustomSnackBar( context, "Selecione um ícone para a despesa", OrgaliveColors.redDefault );

    } else if ( _controllerLimit.text == "R\$ 0,00" ) {

      CustomSnackBar( context, "Informe um gasto limite mensal para a despesa", OrgaliveColors.redDefault );

    } else {
      _createSpending();
    }
  }

  // criar gasto / categoria
  _createSpending() {

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
            title: const Text("Novo gasto"),
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

                Padding(
                  padding: const EdgeInsets.only( bottom: 20 ),
                  child: FindDropdown(
                    backgroundColor: OrgaliveColors.greyBackground,
                    items: list_icons.listIcons,
                    showSearchBox: false,
                    label: "Selecione uma categoria",
                    labelStyle: const TextStyle(
                      color: OrgaliveColors.whiteSmoke,
                    ),
                    titleStyle: const TextStyle(
                      color: OrgaliveColors.whiteSmoke,
                    ),
                    errorBuilder: ( context, item ) {
                      return const Center(
                        child: Text(
                          "Nenhum ícone encontrado",
                          style: TextStyle(
                            color: OrgaliveColors.whiteSmoke,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                    emptyBuilder: ( item ) {
                      return const Center(
                        child: Text(
                          "Nenhum ícone encontrado",
                          style: TextStyle(
                            color: OrgaliveColors.whiteSmoke,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                    onChanged: ( item ) {
                      setState(() {
                        _icon = item;
                      });
                    },
                    dropdownBuilder: (BuildContext context, item) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: OrgaliveColors.silver,
                          ),
                          borderRadius: BorderRadius.circular(5),
                          color: OrgaliveColors.greyBackground,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: OrgaliveColors.bossanova,
                            child: ( item.toString().contains("IconData(U+0F52A)") || item.toString().contains("IconData(U+0F531)") )
                            ? Icon(
                              ( item.toString().contains("IconData(U+0F52A)") )
                              ? list_icons.listIcons[0]
                              : list_icons.listIcons[1],
                              color: OrgaliveColors.silver,
                            )
                            : FaIcon(
                              ( !item.toString().contains("IconData(U+0F5DE)") )
                              ? list_icons.listIcons[2]
                              : ( !item.toString().contains("IconData(U+0F201)") )
                              ? list_icons.listIcons[3]
                              : ( !item.toString().contains("IconData(U+0F6D3)") )
                              ? list_icons.listIcons[4]
                              : ( !item.toString().contains("IconData(U+0F44B)") )
                              ? list_icons.listIcons[5]
                              : ( !item.toString().contains("IconData(U+0F805)") )
                              ? list_icons.listIcons[6]
                              : ( !item.toString().contains("IconData(U+0F549)") )
                              ? list_icons.listIcons[7]
                              : ( !item.toString().contains("IconData(U+0F553)") )
                              ? list_icons.listIcons[8]
                              : ( !item.toString().contains("IconData(U+0F015)") )
                              ? list_icons.listIcons[9]
                              : list_icons.listIcons[10],
                              color: OrgaliveColors.silver,
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                (item == null)
                                ? "Selecione uma categoria"
                                : ( item.toString().contains("IconData(U+0F52A)") )
                                ? "Mercado"
                                : ( item.toString().contains("IconData(U+0F531)") )
                                ? "Viagens"
                                : ( item.toString().contains("IconData(U+0F5DE)") )
                                ? "Transporte"
                                : ( item.toString().contains("IconData(U+0F201)") )
                                ? "Investimentos"
                                : ( item.toString().contains("IconData(U+0F6D3)") )
                                ? "Animais de estimação"
                                : ( item.toString().contains("IconData(U+0F44B)") )
                                ? "Academia"
                                : ( item.toString().contains("IconData(U+0F805)") )
                                ? "Alimentação"
                                : ( item.toString().contains("IconData(U+0F549)") )
                                ? "Estudos"
                                : ( item.toString().contains("IconData(U+0F553)") )
                                ? "Vestimentas"
                                : ( item.toString().contains("IconData(U+0F015)") )
                                ? "Casa"
                                : "Hoobies",
                                style: const TextStyle(
                                  color: OrgaliveColors.whiteSmoke,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },

                    // constroi a exibição dos icones
                    dropdownItemBuilder: ( BuildContext context, item, bool isSelected ) {
                      return Container(
                        decoration: !isSelected
                        ? null
                        : BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: OrgaliveColors.bossanova,
                        ),
                        child: Card(
                          color: OrgaliveColors.greyDefault,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ListTile(
                            selected: isSelected,
                            leading: CircleAvatar(
                              backgroundColor: OrgaliveColors.bossanova,
                              child: ( item.toString().contains("IconData(U+0F52A)") || item.toString().contains("IconData(U+0F531)") )
                              ? Icon(
                                ( item.toString().contains("IconData(U+0F52A)") )
                                ? list_icons.listIcons[0]
                                : list_icons.listIcons[1],
                                color: OrgaliveColors.silver,
                              )
                              : FaIcon(
                                ( !item.toString().contains("IconData(U+0F5DE)") )
                                ? list_icons.listIcons[2]
                                : ( !item.toString().contains("IconData(U+0F201)") )
                                ? list_icons.listIcons[3]
                                : ( !item.toString().contains("IconData(U+0F6D3)") )
                                ? list_icons.listIcons[4]
                                : ( !item.toString().contains("IconData(U+0F44B)") )
                                ? list_icons.listIcons[5]
                                : ( !item.toString().contains("IconData(U+0F805)") )
                                ? list_icons.listIcons[6]
                                : ( !item.toString().contains("IconData(U+0F549)") )
                                ? list_icons.listIcons[7]
                                : ( !item.toString().contains("IconData(U+0F553)") )
                                ? list_icons.listIcons[8]
                                : ( !item.toString().contains("IconData(U+0F015)") )
                                ? list_icons.listIcons[9]
                                : list_icons.listIcons[10],
                                color: OrgaliveColors.silver,
                              ),
                            ),
                            title: Text(
                              ( item.toString().contains("IconData(U+0F52A)") )
                              ? "Mercado"
                              : ( item.toString().contains("IconData(U+0F531)") )
                              ? "Viagens"
                              : ( item.toString().contains("IconData(U+0F5DE)") )
                              ? "Transporte"
                              : ( item.toString().contains("IconData(U+0F201)") )
                              ? "Investimentos"
                              : ( item.toString().contains("IconData(U+0F6D3)") )
                              ? "Animais de estimação"
                              : ( item.toString().contains("IconData(U+0F44B)") )
                              ? "Academia"
                              : ( item.toString().contains("IconData(U+0F805)") )
                              ? "Alimentação"
                              : ( item.toString().contains("IconData(U+0F549)") )
                              ? "Estudos"
                              : ( item.toString().contains("IconData(U+0F553)") )
                              ? "Vestimentas"
                              : ( item.toString().contains("IconData(U+0F015)") )
                              ? "Casa"
                              : "Hoobies",
                              style: const TextStyle(
                                color: OrgaliveColors.whiteSmoke,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
                      labelText: "Limite gasto",
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
                      "Cadastrar despesa",
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
