// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

// import dos modelos
import 'package:orgalive/core/firebase/model_firebase.dart';
import 'package:orgalive/core/styles/orgalive_colors.dart';
import 'package:orgalive/model/model_release.dart';

// import das telas
import 'package:orgalive/screens/releases/widgets/card_date_widget.dart';
import 'package:orgalive/screens/widgets/loading_connection.dart';

// gerenciadores de estado
import 'package:orgalive/mobx/connection/connection_mobx.dart';
import 'package:orgalive/blocs/releases/release_bloc.dart';
import 'package:orgalive/mobx/users/users_mobx.dart';

class Releases extends StatefulWidget {
  const Releases({Key? key}) : super(key: key);

  @override
  _ReleasesState createState() => _ReleasesState();
}

class _ReleasesState extends State<Releases> {

  // variaveis da tela
  final DateTime _currentYear = DateTime.now();

  // gerenciadores de estado
  final ReleaseBloc _bloc = ReleaseBloc();
  late ConnectionMobx _connectionMobx;
  late UsersMobx _usersMobx;

  // recarregamento da tela
  _refresh() async {
    await Future.delayed(const Duration(seconds: 0, milliseconds: 200));
    if ( _bloc.isLoading == false ) {
      _bloc.clear();
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

    _usersMobx = Provider.of<UsersMobx>(context);
    _bloc.getReleases(_usersMobx.userUid);
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
            child: StreamBuilder(
              stream: _bloc.listen,
              builder: ( context, snapshot ) {

                // verificando conexão
                if ( _bloc.listReleases.isNotEmpty ) {

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

                  } else if ( _bloc.listReleases.isEmpty ) {

                    if ( _bloc.isLoading == true ) {

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

                  }  else if ( _bloc.listReleases == [] ) {

                    if ( _bloc.isLoading == true ) {

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
                  itemCount: _bloc.listReleases.length,
                  itemBuilder: ( context, index ) {

                    ModelRelease modelRelease = _bloc.listReleases[index];

                    return Column(
                      children: [
                        ( index == 0 )
                        ? CalendarTimeline(
                          initialDate: _currentYear,
                          firstDate: DateTime(2021, 12, 06),
                          lastDate: DateTime(2023, 12, 06),
                          leftMargin: 16,
                          onDateSelected: (date) => _bloc.filterReleases( date!, context ),
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
                          title: modelRelease.date,
                        ),

                        // lista da descricao e dos valores
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: ( modelRelease.type == "Despesa" )
                            ? OrgaliveColors.redDefault
                            : OrgaliveColors.greenDefault,
                            radius: 22,
                            child: FaIcon(
                              ( modelRelease.type == "Despesa" )
                              ? FontAwesomeIcons.arrowTrendDown
                              : ( modelRelease.type == "Lucro" )
                              ? FontAwesomeIcons.moneyBillTrendUp
                              : FontAwesomeIcons.moneyBillTransfer,
                              color: OrgaliveColors.whiteSmoke,
                              size: 25,
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  modelRelease.description,
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
                                  color: ( modelRelease.type == "Despesa" )
                                  ? OrgaliveColors.redDefault
                                  : OrgaliveColors.greenDefault,
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
                                  : ( modelRelease.type == "Despesa" && modelRelease.status == 0 )
                                  ? "Não pago"
                                  : ( modelRelease.type == "Despesa" && modelRelease.status == 1 )
                                  ? "Pago"
                                  : ( modelRelease.type == "Transferência" && modelRelease.status == 0 )
                                  ? "Não transferido"
                                  : "Transferido",
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
