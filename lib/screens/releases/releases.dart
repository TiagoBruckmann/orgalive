// imports nativos do flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:calendar_timeline/calendar_timeline.dart';

// import dos modelos
import 'package:orgalive/model/core/firebase/model_firebase.dart';
import 'package:orgalive/model/core/styles/orgalive_colors.dart';
import 'package:orgalive/model/functions/releases/releases.dart';
import 'package:orgalive/model/model_release.dart';

// import das telas
import 'package:orgalive/screens/releases/widgets/card_date_widget.dart';

class Releases extends StatefulWidget {
  const Releases({Key? key}) : super(key: key);

  @override
  _ReleasesState createState() => _ReleasesState();
}

class _ReleasesState extends State<Releases> {

  // variaveis da tela
  final List<ModelRelease> _listRelease = [];
  bool _isLoading =  true;
  final DateTime _currentYear = DateTime.now();
  String? _userUid;

  // variaveis do banco
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // busca dos lancamentos do mes
  Future<List<ModelRelease>> _getReleases() async {

    if ( _userUid == null ) {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? userData = auth.currentUser;

      _userUid = userData!.uid;
    }

    String month = ReleaseFunction().formatDate(_currentYear.month);
    String date = "${_currentYear.year}$month";

    if ( _listRelease.isEmpty && _isLoading == true ) {

      var data = await _db.collection("releases")
        .where("user_uid", isEqualTo: _userUid)
        .get();

      List<ModelRelease> list = [];
      for ( var item in data.docs ) {

        if ( item["document"].toString().contains(date) ) {

          ModelRelease modelRelease = ModelRelease(
            item["account_id"],
            item["category"],
            ReleaseFunction().formatMonth(item["date"]),
            item["description"],
            item["document"],
            item["type"],
            item["user_uid"],
            item["value"],
            item["status"],
          );

          list.add(modelRelease);
        }
      }

      setState(() {
        _listRelease.addAll(list);
        _isLoading = false;
      });

    }

    return _listRelease;
  }

  // recarregamento da tela
  _refresh() async {

    await Future.delayed(const Duration(seconds: 0, milliseconds: 200));

    if ( _isLoading == false ) {

      setState(() {
        _isLoading = true;
        _listRelease.clear();
      });

    }
  }

  @override
  void initState() {
    super.initState();
    Analytics().sendScreen("Releases");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lançamentos"),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return _refresh();
        },
        child: FutureBuilder<List<ModelRelease>>(
          future: _getReleases(),
          builder: ( context, snapshot ) {

            // verificando conexão
            if ( _listRelease.isNotEmpty ) {

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

              } else if ( _listRelease.isEmpty ) {

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
                    ),
                  );

                }

              }  else if ( _listRelease == [] ) {

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
                    ),
                  );

                }

              }
            }

            return ListView.builder(
              itemCount: _listRelease.length,
              itemBuilder: ( context, index ) {

                ModelRelease modelRelease = _listRelease[index];

                return Column(
                  children: [
                    ( index == 0 )
                    ? CalendarTimeline(
                      initialDate: _currentYear,
                      firstDate: DateTime(2021, 12, 06),
                      lastDate: DateTime(2023, 12, 06),
                      leftMargin: 16,
                      onDateSelected: (date) => print(date),
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
                          Text(
                            "${modelRelease.description}",
                            style: const TextStyle(
                              color: OrgaliveColors.whiteSmoke,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
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
                            "Conta inicial",
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
        )
      )
    );
  }
}
