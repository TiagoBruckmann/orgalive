// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:graphic/graphic.dart';

// import dos modelos
import 'package:orgalive/model/core/firebase/model_firebase.dart';
import 'package:orgalive/model/core/styles/orgalive_colors.dart';
import 'package:orgalive/screens/reports/data.dart';

// import das telas
import 'package:orgalive/screens/widgets/loading_connection.dart';
import 'package:orgalive/screens/reports/detail_reports.dart';

// gerenciadores de estado
import 'package:orgalive/mobx/connection/connection_mobx.dart';

class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {

  // variaveis da tela
  final DateTime _currentYear = DateTime.now();

  // gerenciadores de estado
  late ConnectionMobx _connectionMobx;

  // alterar o tipo de relatorio
  _changeType() {

  }

  // filtrar relatorio
  _filterReport() {

  }

  _goToDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => const DetailReports(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Analytics().sendScreen("reports");
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
            title: const Text("Relatórios"),
          ),

          body: ( _connectionMobx.connectionStatus.toString() == "ConnectivityResult.none" )
          ? const LoadingConnection()
          : SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
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

                // tipo de movimentacoes
                GestureDetector(
                  onTap: () {
                    _changeType();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [

                      Text(
                        "Somente movimentações pagas",
                        style: TextStyle(
                          color: OrgaliveColors.silver,
                          fontSize: 14,
                        ),
                      ),

                      Text(
                        "Alterar",
                        style: TextStyle(
                          color: OrgaliveColors.whiteSmoke,
                          fontSize: 14,
                        ),
                      ),

                    ],
                  ),
                ),

                // entrada vs saida
                Padding(
                  padding: const EdgeInsets.only( top: 16 ),
                  child: Card(
                    color: OrgaliveColors.greyDefault,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric( horizontal: 16, vertical: 20 ),
                      child: Column(
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [

                              Text(
                                "Entrada x saídas",
                                style: TextStyle(
                                  color: OrgaliveColors.whiteSmoke,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),

                              Text(
                                "Todas as contas",
                                style: TextStyle(
                                  color: OrgaliveColors.whiteSmoke,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          // grafico em linha
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: 350,
                            height: 200,
                            child: Chart(
                              data: basicData,
                              variables: {
                                'categoria': Variable(
                                  accessor: (Map map) => map['categoria'] as String,
                                ),
                                'valor': Variable(
                                  accessor: (Map map) => map['valor'] as num,
                                ),
                              },
                              elements: [
                                IntervalElement(
                                  label: LabelAttr(
                                    encoder: (tuple) => Label(
                                      tuple['valor'].toString(),
                                    ),
                                  ),
                                  elevation: ElevationAttr(
                                    value: 0,
                                    updaters: {
                                      'tap': {true: (_) => 5}
                                    },
                                  ),
                                  color: ColorAttr(
                                    value: Defaults.primaryColor,
                                    updaters: {
                                      'tap': {false: (color) => color.withAlpha(100)},
                                    },
                                  ),
                                ),
                              ],
                              axes: [
                                Defaults.horizontalAxis,
                                Defaults.verticalAxis,
                              ],
                            ),
                          ),

                          // detalhe dos gastos
                          Padding(
                            padding: const EdgeInsets.only( top: 15 ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [

                                Text(
                                  "R\$ 0,00",
                                  style: TextStyle(
                                    color: OrgaliveColors.greenDefault,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                Text(
                                  "R\$ -426,88",
                                  style: TextStyle(
                                    color: OrgaliveColors.redDefault,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                Text(
                                  "R\$ 1.514,49",
                                  style: TextStyle(
                                    color: OrgaliveColors.blueDefault,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                              ],
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [

                              Text(
                                "Receitas",
                                style: TextStyle(
                                  color: OrgaliveColors.whiteSmoke,
                                  fontSize: 14,
                                ),
                              ),

                              Text(
                                "Despesas",
                                style: TextStyle(
                                  color: OrgaliveColors.whiteSmoke,
                                  fontSize: 14,
                                ),
                              ),

                              Text(
                                "Saldo",
                                style: TextStyle(
                                  color: OrgaliveColors.whiteSmoke,
                                  fontSize: 14,
                                ),
                              ),

                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                ),

                // despesas por categoria
                Padding(
                  padding: const EdgeInsets.only( top: 16 ),
                  child: Card(
                    color: OrgaliveColors.greyDefault,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric( horizontal: 16, vertical: 20 ),
                      child: Column(
                        children: [

                          const Text(
                            "Despesas por categorias",
                            style: TextStyle(
                              color: OrgaliveColors.whiteSmoke,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          // grafico chart
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: 350,
                            height: 225,
                            child: Chart(
                              data: basicData,
                              variables: {
                                'categoria': Variable(
                                  accessor: (Map map) => map['categoria'] as String,
                                ),
                                'valor': Variable(
                                  accessor: (Map map) => map['valor'] as num,
                                ),
                              },
                              transforms: [
                                Proportion(
                                  variable: 'valor',
                                  as: 'percent',
                                ),
                              ],
                              elements: [
                                IntervalElement(
                                  position: Varset('percent') / Varset('categoria'),
                                  color: ColorAttr(
                                    variable: 'categoria',
                                    values: Defaults.colors10,
                                  ),
                                  modifiers: [StackModifier()],
                                ),
                              ],
                              coord: PolarCoord(
                                transposed: true,
                                dimCount: 1,
                                startRadius: 0.4,
                              ),
                              selections: {'tap': PointSelection()},
                            ),
                          ),

                          // casa
                          GestureDetector(
                            onTap: () {
                              _goToDetail();
                            },
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: OrgaliveColors.darkGray,
                                radius: 20,
                                child: FaIcon(
                                  FontAwesomeIcons.house,
                                  color: OrgaliveColors.bossanova,
                                  size: 18,
                                ),
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [

                                  Text(
                                    "Casa",
                                    style: TextStyle(
                                      color: OrgaliveColors.whiteSmoke,
                                      fontSize: 15,
                                    ),
                                  ),

                                  Text(
                                    "R\$ 300,00",
                                    style: TextStyle(
                                      color: OrgaliveColors.whiteSmoke,
                                      fontSize: 15,
                                    ),
                                  ),

                                ],
                              ),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Text(
                                    "70,28%",
                                    style: TextStyle(
                                      color: OrgaliveColors.silver,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // lazer e hobbies
                          ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: OrgaliveColors.darkGray,
                              radius: 20,
                              child: FaIcon(
                                FontAwesomeIcons.faceLaughSquint,
                                color: OrgaliveColors.bossanova,
                                size: 18,
                              ),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [

                                Text(
                                  "Lazer e Hobbies",
                                  style: TextStyle(
                                    color: OrgaliveColors.whiteSmoke,
                                    fontSize: 15,
                                  ),
                                ),

                                Text(
                                  "R\$ 119,90",
                                  style: TextStyle(
                                    color: OrgaliveColors.whiteSmoke,
                                    fontSize: 15,
                                  ),
                                ),

                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Text(
                                  "28,09%",
                                  style: TextStyle(
                                    color: OrgaliveColors.silver,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // assinaturas
                          ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: OrgaliveColors.darkGray,
                              radius: 20,
                              child: FaIcon(
                                FontAwesomeIcons.desktop,
                                color: OrgaliveColors.bossanova,
                                size: 18,
                              ),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [

                                Text(
                                  "Assinaturas e serviços",
                                  style: TextStyle(
                                    color: OrgaliveColors.whiteSmoke,
                                    fontSize: 15,
                                  ),
                                ),

                                Text(
                                  "R\$ 6,98",
                                  style: TextStyle(
                                    color: OrgaliveColors.whiteSmoke,
                                    fontSize: 15,
                                  ),
                                ),

                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Text(
                                  "1,64%",
                                  style: TextStyle(
                                    color: OrgaliveColors.silver,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
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
