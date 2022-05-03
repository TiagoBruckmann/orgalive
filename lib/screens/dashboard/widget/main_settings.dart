// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos modelos
import 'package:orgalive/core/styles/orgalive_colors.dart';
import 'package:orgalive/core/routes/shared_routes.dart';

// import dos pacotes
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

// injecao de dependencias
import 'package:orgalive/mobx/accounts/default_account_mobx.dart';

class MainSettings extends StatefulWidget {

  final String userUid;
  const MainSettings({ Key? key, required this.userUid }) : super(key: key);

  @override
  _MainSettingsState createState() => _MainSettingsState();
}

class _MainSettingsState extends State<MainSettings> {

  // injecao de dependencias
  final DefaultAccountMobx _defaultAccountMobx = DefaultAccountMobx();

  // variaveis do banco
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // buscar contas
  _getAccounts() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? userData = auth.currentUser;

    dynamic data = await _db.collection("accounts").where("user_uid", isEqualTo: userData!.uid).get();
    for ( dynamic item in data.docs ) {

      if ( item["default"] == true ) {
        _defaultAccountMobx.setData(item);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 130, 16, 5),
      child: Card(
        color: OrgaliveColors.greyDefault,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular( 10 ),
        ),
        child: Observer(
          builder: ( builder ) {

            return Column(
              children: [

                // saldo geral
                ListTile(
                  title: const Text(
                    "Saldo geral",
                    style: TextStyle(
                      color: OrgaliveColors.silver,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        ( _defaultAccountMobx.valueVisible == true )
                        ? "R\$ ${_defaultAccountMobx.value}"
                        : "R\$  - - - - - -",
                        style: const TextStyle(
                          color: OrgaliveColors.whiteSmoke,
                          fontSize: 20,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          _defaultAccountMobx.updVisible();
                        },
                        child: Icon(
                          ( _defaultAccountMobx.valueVisible == true )
                          ? Icons.visibility_off
                          : Icons.visibility,
                          color: OrgaliveColors.darkGray,
                          size: 30,
                        ),
                      ),

                    ],
                  ),
                ),

                const Divider(
                  color: OrgaliveColors.bossanova,
                  height: 10,
                  indent: 16,
                  endIndent: 16,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [

                    Padding(
                      padding: EdgeInsets.only( left: 16 ),
                      child: Text(
                        "Minhas contas",
                        style: TextStyle(
                          color: OrgaliveColors.whiteSmoke,
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        ),
                      ),
                    ),

                  ],
                ),

                // contas
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: OrgaliveColors.darkGray,
                    radius: 30,
                    child: Icon(
                      Icons.account_balance,
                      color: OrgaliveColors.bossanova,
                      size: 30,
                    ),
                  ),
                  title: Text(
                    _defaultAccountMobx.account,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      const Text(
                        "Outros",
                        style: TextStyle(
                          color: OrgaliveColors.silver,
                          fontSize: 15,
                        ),
                      ),

                      Text(
                        ( _defaultAccountMobx.valueVisible == true )
                        ? "R\$ ${_defaultAccountMobx.value}"
                        : "R\$  - - - - - -",
                        style: const TextStyle(
                          color: OrgaliveColors.blueDefault,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),

                    ],
                  ),
                ),

                SizedBox(
                  width: MediaQuery.of(context).size.width - 65,
                  child: Padding(
                    padding: const EdgeInsets.only( top: 10, bottom: 20 ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: OrgaliveColors.greenDefault,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        SharedRoutes().goToSettingAccounts(context);
                      },
                      child: const Text(
                        "Gerenciar contas",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            );

          },
        )
      ),
    );
  }
}
