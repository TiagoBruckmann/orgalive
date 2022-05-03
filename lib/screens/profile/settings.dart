// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

// import dos modelos
import 'package:orgalive/core/styles/orgalive_colors.dart';
import 'package:orgalive/core/routes/shared_routes.dart';

// import das telas
import 'package:orgalive/screens/profile/widgets/app_bar_profile.dart';
import 'package:orgalive/screens/widgets/loading_connection.dart';

// gerenciadores de estado
import 'package:orgalive/mobx/connection/connection_mobx.dart';

class Settings extends StatefulWidget {

  final String userUid;
  final String photo;
  final String user;
  const Settings({ Key? key, required this.userUid, required this.photo, required this.user }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  // gerenciadores de estado
  late ConnectionMobx _connectionMobx;

  // desconectar
  _disconnect() {

    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    SharedRoutes().goToInfoRemoveUntil(context);

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
          appBar: AppBarProfile(
            userUid: widget.userUid,
            photo: widget.photo,
            user: widget.user,
            context: context,
          ),

          body: ( _connectionMobx.connectionStatus.toString() == "ConnectivityResult.none" )
          ? const LoadingConnection()
          : SingleChildScrollView(
            padding: const EdgeInsets.symmetric( horizontal: 16 ),
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Card(
                    color: OrgaliveColors.greyDefault,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular( 10 ),
                    ),
                    child: Column(
                      children: [

                        // configuracoes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [

                            Padding(
                              padding: EdgeInsets.only( left: 16, top: 20, bottom: 10, ),
                              child: Text(
                                "Configurar",
                                style: TextStyle(
                                  color: OrgaliveColors.whiteSmoke,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),

                          ],
                        ),

                        const Divider(
                          color: OrgaliveColors.bossanova,
                          thickness: 2,
                          height: 10,
                          indent: 16,
                          endIndent: 16,
                        ),

                        // contas
                        GestureDetector(
                          onTap: () {
                            SharedRoutes().goToSettingAccounts(context);
                          },
                          child: const ListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.buildingColumns,
                              color: OrgaliveColors.darkGray,
                              size: 25,
                            ),
                            title: Text(
                              "Contas",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        const Divider(
                          color: OrgaliveColors.bossanova,
                          thickness: 2,
                          height: 0,
                          indent: 16,
                          endIndent: 16,
                        ),

                        // Cartoes de credito
                        GestureDetector(
                          onTap: () {
                            SharedRoutes().goToCreditCard(context);
                          },
                          child: const ListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.solidCreditCard,
                              color: OrgaliveColors.darkGray,
                              size: 25,
                            ),
                            title: Text(
                              "Cartões de crédito",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        const Divider(
                          color: OrgaliveColors.bossanova,
                          thickness: 2,
                          height: 0,
                          indent: 16,
                          endIndent: 16,
                        ),

                        // Categorias
                        GestureDetector(
                          onTap: () {
                            SharedRoutes().goToCategories(context);
                          },
                          child: const ListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.folder,
                              color: OrgaliveColors.darkGray,
                              size: 25,
                            ),
                            title: Text(
                              "Categorias",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        const Divider(
                          color: OrgaliveColors.bossanova,
                          thickness: 2,
                          height: 0,
                          indent: 16,
                          endIndent: 16,
                        ),

                        // Categorias
                        GestureDetector(
                          onTap: () {
                            SharedRoutes().goToTags( context );
                          },
                          child: const ListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.tag,
                              color: OrgaliveColors.darkGray,
                              size: 25,
                            ),
                            title: Text(
                              "Tags",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        const Divider(
                          color: OrgaliveColors.bossanova,
                          thickness: 2,
                          height: 0,
                          indent: 16,
                          endIndent: 16,
                        ),

                        // desconectar
                        GestureDetector(
                          onTap: () {
                            _disconnect();
                          },
                          child: const ListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.powerOff,
                              color: OrgaliveColors.darkGray,
                              size: 25,
                            ),
                            title: Text(
                              "Desconectar",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                      ],
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
