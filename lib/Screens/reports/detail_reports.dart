// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:graphic/graphic.dart';
import 'package:intl/intl.dart';

// import dos modelos
import 'package:orgalive/Model/Core/styles/orgalive_colors.dart';
import 'package:orgalive/Screens/reports/data.dart';

class DetailReports extends StatefulWidget {
  const DetailReports({Key? key}) : super(key: key);

  @override
  _DetailReportsState createState() => _DetailReportsState();
}

class _DetailReportsState extends State<DetailReports> {

  // variaveis da tela
  final DateTime _currentYear = DateTime.now();
  final _monthDayFormat = DateFormat('MM-dd');

  // filtrar relatorio
  _filterReport() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Relatórios"),
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
        child: Column(
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

            // icone
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(
                  backgroundColor: OrgaliveColors.darkGray,
                  radius: 30,
                  child: FaIcon(
                    FontAwesomeIcons.home,
                    color: OrgaliveColors.bossanova,
                    size: 30,
                  ),
                ),
              ],
            ),

            // categoria
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Casa",
                  style: TextStyle(
                    color: OrgaliveColors.whiteSmoke,
                    fontSize: 23,
                  ),
                ),
              ],
            ),

            // grafico
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 350,
              height: 150,
              child: Chart(
                data: timeSeriesSales,
                variables: {
                  'time': Variable(
                    accessor: (TimeSeriesSales datum) => datum.time,
                    scale: TimeScale(
                      formatter: (time) => _monthDayFormat.format(time),
                    ),
                  ),
                  'sales': Variable(
                    accessor: (TimeSeriesSales datum) => datum.sales,
                  ),
                },
                elements: [LineElement()],
                axes: [
                  Defaults.horizontalAxis,
                  Defaults.verticalAxis,
                ],
                selections: {
                  'touchMove': PointSelection(
                    on: {
                      GestureType.scaleUpdate,
                      GestureType.tapDown,
                      GestureType.longPressMoveUpdate
                    },
                    dim: 1,
                  )
                },
                tooltip: TooltipGuide(
                  followPointer: [false, true],
                  align: Alignment.topLeft,
                  offset: const Offset(-20, -20),
                ),
                crosshair: CrosshairGuide(followPointer: [false, true]),
              ),
            ),

            // total de gastos
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 16, 20), // symmetric( vertical: 20 ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [

                  Text.rich(
                    TextSpan(
                      text: "Despesa total: ",
                      style: TextStyle(
                        color: OrgaliveColors.silver,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: "R\$ 300,00",
                          style: TextStyle(
                            color: OrgaliveColors.redDefault,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),

            // categoria
            Card(
              color: OrgaliveColors.bossanova,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [

                    Flexible(
                      child: Text(
                        "Casa",
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          fontSize: 15,
                          color: OrgaliveColors.whiteSmoke,
                        ),
                      ),
                    ),

                    Text(
                      "300,00",
                      style: TextStyle(
                        fontSize: 15,
                        color: OrgaliveColors.whiteSmoke,
                      ),
                    ),

                  ],
                ),
              ),
            ),

            // lista de gastos
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [

                  Text(
                    "Casa",
                    style: TextStyle(
                      fontSize: 14,
                      color: OrgaliveColors.whiteSmoke,
                    ),
                  ),

                  Text(
                    "04/12/2021",
                    style: TextStyle(
                      fontSize: 14,
                      color: OrgaliveColors.silver,
                    ),
                  ),

                  Text(
                    "R\$ 119,90",
                    style: TextStyle(
                      fontSize: 14,
                      color: OrgaliveColors.whiteSmoke,
                    ),
                  ),

                ],
              ),
              subtitle: const Text(
                "Conta inicial",
                style: TextStyle(
                  fontSize: 14,
                  color: OrgaliveColors.silver,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
