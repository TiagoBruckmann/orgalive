// imports nativos do flutter
import 'package:flutter/material.dart';
import 'package:orgalive/model/core/styles/app_images.dart';

// import dos modelos
import 'package:orgalive/model/core/styles/orgalive_colors.dart';
import 'package:orgalive/model/core/styles/app_gradient.dart';

// import das telas
import 'package:orgalive/screens/dashboard/widget/more_info_essentials.dart';

class AppBarMoreInfo extends PreferredSize {

  AppBarMoreInfo({ Key? key })
  : super(
    key: key,
    preferredSize: const Size.fromHeight(620),
    child: SizedBox(
      height: 650,
      child: Stack(
        children: [
          Container(
            height: 280,
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(gradient: AppGradients.linear),
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Column(
                children: const [

                  // logo
                  /*
                  Center(
                    child: AppImages.logo,
                  ),
                  */

                  Padding(
                    padding: EdgeInsets.symmetric( vertical: 16 ),
                    child: Text(
                      "Entenda mais sobre",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: OrgaliveColors.silver,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric( vertical: 16 ),
                    child: Text(
                      "Equilíbrio financeiro",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: OrgaliveColors.whiteSmoke,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
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
          ),
          const Align(
            alignment: Alignment(50, 12),
            child: MoreInfoEssentials(),
          ),
        ],
      ),
    ),
  );
}
