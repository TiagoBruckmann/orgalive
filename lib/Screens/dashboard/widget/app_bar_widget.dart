// imports nativos do flutter
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import dos pacotes
import 'package:orgalive/Model/Core/styles/orgalive_colors.dart';
import 'package:orgalive/Model/Core/styles/app_gradient.dart';

// import das telas
import 'package:orgalive/Screens/dashboard/widget/main_settings.dart';

class AppBarWidget extends PreferredSize {

  final String user;
  final String timeOfDay;

  AppBarWidget({Key? key,  required this.user, required this.timeOfDay })
    : super(key: key,
    preferredSize: const Size.fromHeight(400),
    child: SizedBox(
      height: 400,
      child: Stack(
        children: [
          Container(
            height: 180,
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric( horizontal: 20 ),
            decoration: const BoxDecoration( gradient: AppGradients.linear ),
            child: Padding(
              padding: const EdgeInsets.only( top: 50 ),
              child: ListTile(
                leading: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage("https://ui-avatars.com/api/?name=$user"),
                    ),
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: "$timeOfDay\n",
                        style: const TextStyle(
                          color: OrgaliveColors.silver,
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(
                            text: "$user!",
                            style: const TextStyle(
                              color: OrgaliveColors.whiteSmoke,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        //
                      },
                      child: Card(
                        color: OrgaliveColors.matterhorn,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular( 10 ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: FaIcon(
                            FontAwesomeIcons.bell,
                            color: OrgaliveColors.whiteSmoke,
                            size: 22,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment(30.0, 8.0),
            child: MainSettings(),
          ),
        ],
      ),
    ),
  );
}