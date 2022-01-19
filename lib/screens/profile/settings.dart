// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import dos modelos
import 'package:orgalive/model/core/styles/orgalive_colors.dart';

// import das telas
import 'package:orgalive/screens/profile/widgets/app_bar_profile.dart';
import 'package:orgalive/screens/dashboard/categories_essentials.dart';
import 'package:orgalive/screens/dashboard/setting_accounts.dart';
import 'package:orgalive/screens/profile/credit_card.dart';
import 'package:orgalive/screens/login/info.dart';

class Settings extends StatefulWidget {

  final String userUid;
  final String photo;
  final String user;
  const Settings({ Key? key, required this.userUid, required this.photo, required this.user }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  // contas
  _goToAccount() {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => SettingAccounts(
          userUid: widget.userUid,
          value: 150.00,
        ),
      ),
    );

  }

  // ir para os cartoes de credito
  _goToCreditCard() {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => CreditCard(
          userUid: widget.userUid,
        ),
      ),
    );

  }

  // ir para as categorias
  _goToCategories() {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => const CategoriesEssentials(),
      )
    );

  }

  // ir para as tags
  _goToTags() {

  }

  // desconectar
  _disconnect() {

    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (builder) => const Info(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProfile(
        userUid: widget.userUid,
        photo: widget.photo,
        user: widget.user,
        context: context,
      ),

      body: SingleChildScrollView(
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
                        _goToAccount();
                      },
                      child: const ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.university,
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
                        _goToCreditCard();
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
                        _goToCategories();
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
                        _goToTags();
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
  }
}
