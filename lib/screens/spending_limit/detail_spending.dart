// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:calendar_timeline/calendar_timeline.dart';

// import dos modelos
import 'package:orgalive/model/core/firebase/model_firebase.dart';
import 'package:orgalive/model/core/styles/orgalive_colors.dart';

class DetailSpending extends StatefulWidget {

  final String id;
  final String name;
  const DetailSpending({ Key? key, required this.id, required this.name }) : super(key: key);

  @override
  _DetailSpendingState createState() => _DetailSpendingState();
}

class _DetailSpendingState extends State<DetailSpending> {

  // controladores de texto
  final TextEditingController _controllerSearch = TextEditingController();

  // variaveis da tela
  final DateTime _currentYear = DateTime.now();
  final _lastMonth = DateTime.monthsPerYear - 1;
  String _month = "Dezembro";

  _getMonth() {

    switch ( _lastMonth ) {
      case 1:
        _month = "Janeiro";
        break;
      case 2:
        _month = "Fevereiro";
        break;
      case 3:
        _month = "março";
        break;
      case 4:
        _month = "Abril";
        break;
      case 5:
        _month = "Maio";
        break;
      case 6:
        _month = "junho";
        break;
      case 7:
        _month = "Julho";
        break;
      case 8:
        _month = "Agosto";
        break;
      case 9:
        _month = "Setembro";
        break;
      case 10:
        _month = "Outubro";
        break;
      case 11:
        _month = "Novembro";
        break;
      case 12:
        _month = "Dezembro";
        break;
      default:
        _month = "Dezembro";
        break;
    }
  }

  // filtrar relatorio
  _filterReport() {

  }

  @override
  void initState() {
    super.initState();
    _getMonth();
    Analytics().sendScreen("detail-spending");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),

      body: Column(
        children: [

          // calendario de relatorios
          CalendarTimeline(
            initialDate: _currentYear,
            firstDate: DateTime(2021, 12, 06),
            lastDate: DateTime(2023, 12, 06),
            leftMargin: 16,
            onDateSelected: (date) {
              _filterReport();
            },
            monthColor: OrgaliveColors.silver,
            dayColor: OrgaliveColors.bossanova,
            activeDayColor: OrgaliveColors.silver,
            activeBackgroundDayColor: OrgaliveColors.bossanova,
            dotsColor: OrgaliveColors.bossanova,
            locale: 'pt_BR',
          ),

          Card(
            color: OrgaliveColors.greyDefault,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular( 10 ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 16, 10),
              child: Column(
                children: [

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
                    children: const [

                      Padding(
                        padding: EdgeInsets.symmetric( horizontal: 10, vertical: 10 ),
                        child: Text(
                          "R\$ 750,00",
                          style: TextStyle(
                            color: OrgaliveColors.whiteSmoke,
                            fontWeight: FontWeight.w700,
                            fontSize: 25,
                          ),
                        ),
                      ),

                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [

                      Text(
                        "de R\$ 750,00",
                        style: TextStyle(
                          color: OrgaliveColors.silver,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),

                    ],
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
                          padding: const EdgeInsets.symmetric( vertical: 8, horizontal: 16 ),
                          child: Row(
                            children: const [

                              FaIcon(
                                FontAwesomeIcons.caretDown,
                                color: OrgaliveColors.greenDefault,
                                size: 18,
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

                      Flexible(
                        child: Text(
                          "Comparado ao mês anterior ($_month)",
                          style: const TextStyle(
                            color: OrgaliveColors.whiteSmoke,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),
          ),

          Card(
            color: OrgaliveColors.greyDefault,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                controller: _controllerSearch,
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  color: OrgaliveColors.whiteSmoke,
                  fontSize: 15,
                ),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(5, 22, 5, 16),
                  hintText: "Lançamentos do mês",
                  hintStyle: const TextStyle(
                    color: OrgaliveColors.whiteSmoke,
                    fontSize: 15,
                  ),
                  suffixIcon: TextButton(
                    onPressed: () {
                      //
                    },
                    child: const FaIcon(
                      FontAwesomeIcons.search,
                      color: OrgaliveColors.silver,
                      size: 18,
                    ),
                  ),
                  filled: true,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: OrgaliveColors.greyDefault,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: OrgaliveColors.greyDefault,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
