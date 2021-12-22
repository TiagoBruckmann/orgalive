// imports nativos do flutter
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:orgalive/Model/Core/styles/orgalive_colors.dart';

class MoreInfo extends StatelessWidget {
  const MoreInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: const [

            /*
            // logo
            Center(
              child: ,
            )
            */

            Text(
              "Entenda mais sobre",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: OrgaliveColors.silver,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

            Text(
              "Equilíbrio financeiro",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: OrgaliveColors.whiteSmoke,
                fontSize: 19,
              ),
            ),

            Text(
              "É a relação perfeita entre o que ganhamos X gastamos, entendendo que nossos gastos se dividem entre Essenciais e Não essenciais.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: OrgaliveColors.silver,
                fontSize: 15,
              ),
            ),

          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
        child: Stack(
          children: [

            Card(
              color: OrgaliveColors.greyDefault,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular( 10 ),
              ),
              child: Column(
                children: [

                  Positioned(
                    top: 2,
                    left: MediaQuery.of(context).size.width / 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Card(
                        color: OrgaliveColors.bossanova,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular( 10 ),
                        ),
                        child: const Text(
                          "Gastos essenciais",
                          style: TextStyle(
                            color: OrgaliveColors.darkGray,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only( left: 16 ),
                    child: Text(
                      "Tudo aquilo que você não pode viver sem!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: OrgaliveColors.whiteSmoke,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [

                      CircleAvatar(
                        backgroundColor: OrgaliveColors.darkGray,
                        radius: 20,
                        child: FaIcon(
                          FontAwesomeIcons.receipt,
                          color: OrgaliveColors.bossanova,
                          size: 20,
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),

          ],
        )
      ),
    );
  }
}
