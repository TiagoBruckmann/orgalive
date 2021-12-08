// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:find_dropdown/find_dropdown.dart';

// import dos modelos
import 'package:orgalive/Model/Core/orgalive_colors.dart';

class BodyFutureReleases extends StatefulWidget {

  final int screenActive;
  const BodyFutureReleases({ Key? key, required this.screenActive }) : super(key: key);

  @override
  _BodyFutureReleasesState createState() => _BodyFutureReleasesState();
}

class _BodyFutureReleasesState extends State<BodyFutureReleases> {

  // configurar o valor da conta
  MoneyMaskedTextController _controllerExpense = MoneyMaskedTextController( leftSymbol: 'R\$ ', thousandSeparator: '.', decimalSeparator: ',' );
  MoneyMaskedTextController _controllerProfit = MoneyMaskedTextController( leftSymbol: 'R\$ ', thousandSeparator: '.', decimalSeparator: ',' );
  MoneyMaskedTextController _controllerTransfer = MoneyMaskedTextController( leftSymbol: 'R\$ ', thousandSeparator: '.', decimalSeparator: ',' );
  TextEditingController _controllerDescription = TextEditingController();

  // variaveis da tela
  final DateTime _currentYear = DateTime.now();
  DateTime? _daySelected;

  _validateFields() {

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [

          // valores
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: TextField(
              controller: ( widget.screenActive == 1 )
              ? _controllerExpense
              : ( widget.screenActive == 2 )
              ? _controllerProfit
              : _controllerTransfer,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              style: const TextStyle(
                color: OrgaliveColors.whiteSmoke,
                fontSize: 20,
              ),
              autofocus: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
                filled: true,
                suffixIcon: Padding(
                  padding: const EdgeInsets.only( top: 10 ),
                  child: FaIcon(
                    ( widget.screenActive == 1 )
                    ? FontAwesomeIcons.solidThumbsDown
                    : ( widget.screenActive == 2 )
                    ? FontAwesomeIcons.solidThumbsUp
                    : FontAwesomeIcons.solidThumbsDown,
                    color: OrgaliveColors.whiteSmoke,
                  ),
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

          // descricao do valor
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: TextField(
              controller: _controllerDescription,
              keyboardType: TextInputType.text,
              style: const TextStyle(
                color: OrgaliveColors.whiteSmoke,
                fontSize: 20,
              ),
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
                labelText: "Descrição",
                labelStyle: const TextStyle(
                  color: OrgaliveColors.silver,
                ),
                filled: true,
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

          // listagem das categorias
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: FindDropdown(
              backgroundColor: OrgaliveColors.greyBackground,
              items: const [
                "Brasil",
                "Itália",
                "Estados Unidos",
                "Canadá",
              ],
              showSearchBox: false,
              // onFind: (items) => _getMedics(),
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
                    "Nenhuma categoria encontrada",
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
                    "Nenhuma categoria encontrada",
                    style: TextStyle(
                      color: OrgaliveColors.whiteSmoke,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
              onChanged: ( item ) {
                print("item => $item");
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
                    leading: const CircleAvatar(
                      backgroundColor: OrgaliveColors.bossanova,
                      child: Icon(
                        Icons.home,
                        color: OrgaliveColors.silver,
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (item == null)
                              ? "Selecione uma categoria"
                              : "$item",
                          style: const TextStyle(
                            color: OrgaliveColors.whiteSmoke,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },

              // constroi a exibição das categorias
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
                      leading: const CircleAvatar(
                        backgroundColor: OrgaliveColors.bossanova,
                        child: Icon(
                          Icons.home,
                          color: OrgaliveColors.silver,
                        ),
                      ),
                      title: Text(
                        "$item",
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

          // pagar com
          ListTile(
            title: const Text(
              "Pagar com",
              style: TextStyle(
                color: OrgaliveColors.silver,
                fontSize: 16,
              ),
            ),

            subtitle: Row(
              children: [

                Card(
                  color: OrgaliveColors.bossanova,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(7),
                    child: Icon(
                      Icons.home,
                      color: OrgaliveColors.silver,
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only( left: 10, ),
                  child: Text(
                    "Conta inicial",
                    style: TextStyle(
                      color: OrgaliveColors.whiteSmoke,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ),

              ],
            ),
          ),

          // data de lancamento
          ListTile(
            title: const Text(
              "Data",
              style: TextStyle(
                color: OrgaliveColors.silver,
                fontSize: 16,
              ),
            ),

            subtitle: CalendarTimeline(
              initialDate: _currentYear,
              firstDate: DateTime(2021, 12, 06),
              lastDate: DateTime(2023, 12, 06),
              leftMargin: 16,
              onDateSelected: (date) {
                _daySelected = date;
                print("date => $date");
                print("_daySelected => $_daySelected");
              },
              monthColor: OrgaliveColors.silver,
              dayColor: OrgaliveColors.bossanova,
              activeDayColor: OrgaliveColors.silver,
              activeBackgroundDayColor: OrgaliveColors.bossanova,
              dotsColor: OrgaliveColors.bossanova,
              locale: 'pt_BR',
            ),
          ),

          // repetir lancamentos
          ListTile(
            title: const Text(
              "Repetir lançamento",
              style: TextStyle(
                color: OrgaliveColors.silver,
                fontSize: 16,
              ),
            ),

            subtitle: Row(
              children: [

                Card(
                  color: OrgaliveColors.bossanova,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular( 20 ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric( horizontal: 20, vertical: 5 ),
                    child: Text(
                      "Fixo",
                      style: TextStyle(
                        color: OrgaliveColors.silver,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

                Card(
                  color: OrgaliveColors.bossanova,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular( 20 ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric( horizontal: 20, vertical: 5 ),
                    child: Text(
                      "Parcelado",
                      style: TextStyle(
                        color: OrgaliveColors.silver,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(
                    ( widget.screenActive == 1 )
                    ? "Cadastrar despesa"
                    : ( widget.screenActive == 2 )
                    ? "Cadastrar lucro"
                    : "Cadastrar transferência",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),

                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: OrgaliveColors.greenDefault,
                padding: const EdgeInsets.fromLTRB(36, 16, 36, 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                _validateFields();
              }
            ),
          ),

        ],
      ),
    );
  }
}
