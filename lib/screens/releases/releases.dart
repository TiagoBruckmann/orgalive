// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

// import dos modelos
import 'package:orgalive/model/core/firebase/model_firebase.dart';
import 'package:orgalive/model/core/styles/orgalive_colors.dart';
import 'package:orgalive/model/functions/releases/releases.dart';
import 'package:orgalive/model/model_release.dart';

// import das telas
import 'package:orgalive/screens/releases/widgets/card_date_widget.dart';
import 'package:orgalive/screens/widgets/loading_connection.dart';

// gerenciadores de estado
import 'package:orgalive/mobx/connection/connection_mobx.dart';
import 'package:orgalive/mobx/releases/release_mobx.dart';

class Releases extends StatefulWidget {
  const Releases({Key? key}) : super(key: key);

  @override
  _ReleasesState createState() => _ReleasesState();
}

class _ReleasesState extends State<Releases> {

  // variaveis da tela
  final DateTime _currentYear = DateTime.now();

  // gerenciadores de estado
  final ReleaseMobx _releaseMobx = ReleaseMobx();
  late ConnectionMobx _connectionMobx;

  // busca dos lancamentos do mes
  Future<List<ModelRelease>> _getReleases() async {

    final FirebaseFirestore _db = FirebaseFirestore.instance;

    if ( _releaseMobx.userUid.isEmpty ) {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? userData = auth.currentUser;

      _releaseMobx.setUserUid(userData!.uid);
    }

    String month = ReleaseFunction().formatDate(_currentYear.month);
    String date = "${_currentYear.year}$month";

    if ( _releaseMobx.listReleases.isEmpty && _releaseMobx.isLoading == true ) {

      var data = await _db.collection("releases")
        .where("user_uid", isEqualTo: _releaseMobx.userUid)
        .get();

      for ( var item in data.docs ) {

        if ( item["document"].toString().contains(date) ) {

          ModelRelease modelRelease = ModelRelease(
            item["account_id"],
            item["category"],
            ReleaseFunction().formatMonth(item["date"]),
            item["description"],
            item["document"],
            item["status"],
            item["type"],
            item["user_uid"],
            item["value"],
          );

          _releaseMobx.setNew(modelRelease);
        }
      }
      _releaseMobx.updLoading(false);
    }
    return _releaseMobx.listReleases;
  }

  // recarregamento da tela
  _refresh() async {
    await Future.delayed(const Duration(seconds: 0, milliseconds: 200));
    if ( _releaseMobx.isLoading == false ) {
      _releaseMobx.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    Analytics().sendScreen("Releases");
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
            title: const Text("Lançamentos"),
          ),

          body: ( _connectionMobx.connectionStatus.toString() == "ConnectivityResult.none" )
          ? const LoadingConnection()
          : RefreshIndicator(
            onRefresh: () {
              return _refresh();
            },
            child: FutureBuilder<List<ModelRelease>>(
              future: _getReleases(),
              builder: ( context, snapshot ) {

                // verificando conexão
                if ( _releaseMobx.listReleases.isNotEmpty ) {

                } else {
                  if ( snapshot.hasError ) {

                    return RefreshIndicator(
                      onRefresh: () {
                        return _refresh();
                      },
                      child: const CircularProgressIndicator(
                        color: OrgaliveColors.darkGray,
                      ),
                    );

                  } else if ( snapshot.connectionState == ConnectionState.waiting ) {

                    return const CircularProgressIndicator(
                      color: OrgaliveColors.darkGray,
                    );

                  } else if ( _releaseMobx.listReleases.isEmpty ) {

                    if ( _releaseMobx.isLoading == true ) {

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
                        ),
                      );

                    }

                  }  else if ( _releaseMobx.listReleases == [] ) {

                    if ( _releaseMobx.isLoading == true ) {

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
                        ),
                      );

                    }

                  }
                }

                return ListView.builder(
                  itemCount: _releaseMobx.listReleases.length,
                  itemBuilder: ( context, index ) {

                    ModelRelease modelRelease = _releaseMobx.listReleases[index];

                    return Column(
                      children: [
                        ( index == 0 )
                        ? CalendarTimeline(
                          initialDate: _currentYear,
                          firstDate: DateTime(2021, 12, 06),
                          lastDate: DateTime(2023, 12, 06),
                          leftMargin: 16,
                          onDateSelected: (date) => _releaseMobx.filterReleases( date!, context ),
                          monthColor: OrgaliveColors.silver,
                          dayColor: OrgaliveColors.bossanova,
                          activeDayColor: OrgaliveColors.silver,
                          activeBackgroundDayColor: OrgaliveColors.bossanova,
                          dotsColor: OrgaliveColors.bossanova,
                          locale: 'pt_BR',
                        )
                        : const Padding(padding: EdgeInsets.zero),

                        // dias de lançamento de valores
                        CardDateWidget(
                          title: "${modelRelease.date}",
                        ),

                        // lista da descricao e dos valores
                        ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: OrgaliveColors.greenDefault,
                            radius: 22,
                            child: Icon(
                              Icons.star,
                              color: OrgaliveColors.whiteSmoke,
                              size: 25,
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  "${modelRelease.description}",
                                  style: const TextStyle(
                                    color: OrgaliveColors.whiteSmoke,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Text(
                                "R\$ ${modelRelease.value}",
                                style: TextStyle(
                                  color: ( modelRelease.type == "Lucro" )
                                  ? OrgaliveColors.greenDefault
                                  : OrgaliveColors.redDefault,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "",
                                style: TextStyle(
                                  color: OrgaliveColors.bossanova,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                ( modelRelease.type == "Lucro" && modelRelease.status == 0 )
                                  ? "Não recebido"
                                  : ( modelRelease.type == "Lucro" && modelRelease.status == 1 )
                                  ? "Recebido"
                                  : ( modelRelease.type != "Lucro" && modelRelease.status == 0 )
                                  ? "Não pago"
                                  : "Pago",
                                style: const TextStyle(
                                  color: OrgaliveColors.bossanova,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    );

                  },
                );
              },
            ),
          ),
        );

      },
    );
  }
}
