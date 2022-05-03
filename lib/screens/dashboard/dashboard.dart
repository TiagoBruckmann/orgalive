// imports nativos do flutter
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

// import dos modelos
import 'package:orgalive/core/functions/shared/shared_functions.dart';
import 'package:orgalive/core/firebase/model_firebase.dart';
import 'package:orgalive/core/styles/orgalive_colors.dart';
import 'package:orgalive/core/routes/shared_routes.dart';
import 'package:orgalive/model/model_categories.dart';

// import das telas
import 'package:orgalive/screens/dashboard/widget/app_bar_widget.dart';
import 'package:orgalive/screens/widgets/loading_connection.dart';

// gerenciadores de estado
import 'package:orgalive/mobx/connection/connection_mobx.dart';
import 'package:orgalive/mobx/users/users_mobx.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  // variaveis da tela
  final int _notifications = 1;
  final List<ModelCategories> _listCategories = [];

  // gerenciadores de estado
  late ConnectionMobx _connectionMobx;
  late UsersMobx _usersMobx;

  // busca das categorias
  _getCategories() async {

    final FirebaseFirestore _db = FirebaseFirestore.instance;
    dynamic data = await _db.collection("categories").get();

    DateTime dateTime = DateTime.now();
    int lastDay = SharedFunctions().getLastDay();

    if ( dateTime.day == lastDay ) {

      dynamic updateData = {
        "percentage": 0,
        "value_spending": "0,00",
      };

      for ( dynamic item in data.docs ) {
        await _db.collection("categories").doc(item["uid"]).update(updateData)
          .onError((error, stackTrace) {
            FirebaseCrashlytics.instance.log("${error.toString()} => categoria == ${item["name"]} <= uid == ${item["uid"]}");
          });
      }

    }

    List<ModelCategories> list = [];

    for ( dynamic item in data.docs ) {

      if ( item["selected"] == true ) {
        ModelCategories modelCategories = ModelCategories(
          item["uid"],
          item["name"],
          item["selected"],
          item["value_spending"],
          item["value_limit"],
          double.parse(item["percentage"].toString()),
        );

        list.add(modelCategories);
      }
    }

    setState(() {
      _listCategories.addAll(list);
    });
  }

  @override
  void initState() {
    super.initState();
    Analytics().sendScreen("Dashboard");
    _getCategories();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    _usersMobx = Provider.of<UsersMobx>(context);
    _usersMobx.getInfo();

    _connectionMobx = Provider.of<ConnectionMobx>(context);

    await _connectionMobx.verifyConnection();
    _connectionMobx.connectivity.onConnectivityChanged.listen(_connectionMobx.updateConnectionStatus);

  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (builder) {

        return Scaffold(
          appBar: AppBarWidget(
            context: context,
            userUid: _usersMobx.userUid,
            user: _usersMobx.user,
            photo: _usersMobx.photo,
            timeOfDay: _usersMobx.timeOfDay,
            notifications: _notifications,
          ),

          body: ( _connectionMobx.connectionStatus.toString() == "ConnectivityResult.none" )
          ? const LoadingConnection()
          : SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
            child: Column(
              children: [

                // limite de gastos
                Padding(
                  padding: const EdgeInsets.symmetric( vertical: 5, horizontal: 0 ),
                  child: Card(
                    color: OrgaliveColors.greyDefault,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular( 10 ),
                    ),
                    child: Column(
                      children: [

                        // Limite de gestos
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            const Padding(
                              padding: EdgeInsets.only( left: 16 ),
                              child: Text(
                                "Limite de gastos",
                                style: TextStyle(
                                  color: OrgaliveColors.whiteSmoke,
                                  fontSize: 20,
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                SharedRoutes().goToSpendings(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only( right: 16, top: 10, ),
                                child: Card(
                                  color: OrgaliveColors.greenDefault,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular( 50 ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(6),
                                    child: FaIcon(
                                      FontAwesomeIcons.plus,
                                      color: OrgaliveColors.greyDefault,
                                      size: 18,
                                    ),
                                  ),

                                ),
                              ),
                            ),

                          ],
                        ),

                        for ( int i = 0; i < _listCategories.length; i++ )
                          Column(
                            children: [

                              // nome do gasto
                              ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    // nome do gasto
                                    Text(
                                      _listCategories[i].name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),

                                    // valor estimado
                                    Text(
                                      "R\$ ${_listCategories[i].valueLimit}",
                                      style: const TextStyle(
                                        color: OrgaliveColors.silver,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),

                                  ],
                                ),
                                subtitle: LinearProgressIndicator(
                                  backgroundColor: OrgaliveColors.silver,
                                  color: OrgaliveColors.fuchsia,
                                  value: _listCategories[i].percentage,
                                ),
                              ),

                              const Divider(
                                color: OrgaliveColors.bossanova,
                                thickness: 2,
                                height: 10,
                                indent: 16,
                                endIndent: 16,
                              ),

                            ],
                          ),

                      ],
                    ),
                  ),
                ),

                // equilibrio financeiro
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Card(
                    color: OrgaliveColors.greyDefault,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular( 10 ),
                    ),
                    child: Column(
                      children: [

                        // saldo geral
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            const Padding(
                              padding: EdgeInsets.only( left: 16, top: 16 ),
                              child: Text(
                                "Equilibrio financeiro",
                                style: TextStyle(
                                  color: OrgaliveColors.whiteSmoke,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                SharedRoutes().goToMoreInfo(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only( right: 16, top: 10, ),
                                child: Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.only( right: 5 ),
                                      child: FaIcon(
                                        FontAwesomeIcons.circleInfo,
                                        color: OrgaliveColors.darkGray,
                                        size: 15,
                                      ),
                                    ),

                                    Text(
                                      "Saiba mais",
                                      style: TextStyle(
                                        color: OrgaliveColors.silver,
                                        fontSize: 12,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),

                        // gastos essenciais
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [

                            Padding(
                              padding: EdgeInsets.only( top: 10, left: 16, ),
                              child: Text(
                                "Gastos essenciais",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // gastos essenciais
                        ListTile(
                          title: const LinearProgressIndicator(
                            minHeight: 8,
                            backgroundColor: OrgaliveColors.silver,
                            color: OrgaliveColors.greenDefault,
                            value: 0.35,
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [

                              Text(
                                "Limite recomendado de R\$ 862,00",
                                style: TextStyle(
                                  color: OrgaliveColors.silver,
                                  fontSize: 14,
                                ),
                              ),

                              Text(
                                "R\$ 300,00",
                                style: TextStyle(
                                  color: OrgaliveColors.whiteSmoke,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),

                            ],
                          ),
                        ),

                        const Divider(
                          color: OrgaliveColors.bossanova,
                          thickness: 2,
                          height: 10,
                          indent: 16,
                          endIndent: 16,
                        ),

                        // gastos não essenciais
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [

                            Padding(
                              padding: EdgeInsets.only( top: 10, left: 16, ),
                              child: Text(
                                "Gastos não essenciais",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // gastos não essenciais
                        ListTile(
                          title: const LinearProgressIndicator(
                            backgroundColor: OrgaliveColors.silver,
                            color: OrgaliveColors.redDefault,
                            minHeight: 8,
                            value: 1,
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [

                              Text(
                                "Limite recomendado de R\$ 517,20",
                                style: TextStyle(
                                  color: OrgaliveColors.silver,
                                  fontSize: 14,
                                ),
                              ),

                              Text(
                                "R\$ 1.026,88",
                                style: TextStyle(
                                  color: OrgaliveColors.whiteSmoke,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),

                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only( top: 10, bottom: 20 ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: OrgaliveColors.greenDefault,
                              padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              SharedRoutes().goToCategories( context );
                            },
                            child: const Text(
                              "Redefinir categorias essenciais",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),

                /*
                GestureDetector(
                  onTap: () {
                    SharedRoutes().goToPersonalize( context );
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 32,
                    child: Card(
                      color: OrgaliveColors.greyDefault,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular( 10 ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only( top: 15, bottom: 15 ),
                        child: Text(
                          "Personalizar",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: OrgaliveColors.silver,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                 */

              ],
            ),
          ),
        );

      },
    );
  }
}
