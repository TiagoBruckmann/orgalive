// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos modelos
import 'package:orgalive/model/core/styles/orgalive_colors.dart';


// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MoreInfoEssentials extends StatefulWidget {
  const MoreInfoEssentials({Key? key}) : super(key: key);

  @override
  _MoreInfoEssentialsState createState() => _MoreInfoEssentialsState();
}

class _MoreInfoEssentialsState extends State<MoreInfoEssentials> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [

        Stack(
          children: [

            Positioned(
              top: 25,
              width: MediaQuery.of(context).size.width / 2,
              child: Padding(
                padding: const EdgeInsets.only( left: 120, top: 205, right: 80 ),
                child: Card(
                  color: OrgaliveColors.yellowDefault,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular( 2 ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric( vertical: 12 ),
                    child: Text(
                      "Gastos essenciais",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: OrgaliveColors.greyDefault,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 250, 16, 5),
          child: Card(
            color: OrgaliveColors.greyDefault,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular( 10 ),
            ),
            child: Column(
              children: [

                const Padding(
                  padding: EdgeInsets.only( left: 16, top: 35, bottom: 20 ),
                  child: Text(
                    "Tudo aquilo que você não pode viver sem!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: OrgaliveColors.whiteSmoke,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),

                // icones das categorias
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [

                    // recibo
                    CircleAvatar(
                      backgroundColor: OrgaliveColors.darkGray,
                      radius: 20,
                      child: FaIcon(
                        FontAwesomeIcons.receipt,
                        color: OrgaliveColors.whiteSmoke,
                        size: 20,
                      ),
                    ),

                    // estudos
                    CircleAvatar(
                      backgroundColor: OrgaliveColors.freeSpeenchBlue,
                      radius: 20,
                      child: FaIcon(
                        FontAwesomeIcons.graduationCap,
                        color: OrgaliveColors.whiteSmoke,
                        size: 20,
                      ),
                    ),

                    // alimentacao
                    CircleAvatar(
                      backgroundColor: OrgaliveColors.fuchsia,
                      radius: 20,
                      child: FaIcon(
                        FontAwesomeIcons.utensils,
                        color: OrgaliveColors.whiteSmoke,
                        size: 20,
                      ),
                    ),

                    // mercado
                    CircleAvatar(
                      backgroundColor: OrgaliveColors.casaBlanca,
                      radius: 20,
                      child: FaIcon(
                        FontAwesomeIcons.cartShopping,
                        color: OrgaliveColors.whiteSmoke,
                        size: 20,
                      ),
                    ),

                    // saude
                    CircleAvatar(
                      backgroundColor: OrgaliveColors.blueDefault,
                      radius: 20,
                      child: FaIcon(
                        FontAwesomeIcons.briefcaseMedical,
                        color: OrgaliveColors.whiteSmoke,
                        size: 20,
                      ),
                    ),

                  ],
                ),

                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
                  child: Text(
                    "De forma geral, estão nessas categorias despesas com alimentação, moradia, transporte e outros serviços que você precisa usar.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: OrgaliveColors.darkGray,
                      fontSize: 16,
                    ),
                  ),
                ),

                const Divider(
                  color: OrgaliveColors.bossanova,
                  thickness: 3,
                  height: 15,
                  indent: 16,
                  endIndent: 16,
                ),

                const ListTile(
                  leading: Padding(
                    padding: EdgeInsets.only( left: 16 ),
                    child: FaIcon(
                      FontAwesomeIcons.info,
                      color: OrgaliveColors.darkGray,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    "É importante ter em mente que o total não deve ultrapassar metade da renda!",
                    style: TextStyle(
                      color: OrgaliveColors.darkGray,
                      fontSize: 16,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),

      ],
    );
  }
}
