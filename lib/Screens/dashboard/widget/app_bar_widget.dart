// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos modelos
import 'package:orgalive/Model/Core/styles/orgalive_colors.dart';
import 'package:orgalive/Model/Core/styles/app_gradient.dart';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import das telas
import 'package:orgalive/Screens/dashboard/widget/main_settings.dart';
import 'package:orgalive/Screens/profile/notifications.dart';
import 'package:orgalive/Screens/profile/settings.dart';

class AppBarWidget extends PreferredSize {

  final BuildContext context;
  final String user;
  final String timeOfDay;
  final int notifications;

  AppBarWidget({ Key? key, required this.context, required this.user, required this.timeOfDay, required this.notifications })
  : super(
    key: key,
    preferredSize: const Size.fromHeight(410),
    child: SizedBox(
      height: 410,
      child: Stack(
        children: [
          Container(
            height: 200,
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(gradient: AppGradients.linear),
            child: Padding(
              padding: const EdgeInsets.only(top: 70),
              child: ListTile(
                leading: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => Settings(
                          user: user,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://ui-avatars.com/api/?name=$user",
                        ),
                      ),
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

                    // notificacoes
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => const Notifications(),
                          ),
                        );
                      },
                      child: Card(
                        color: OrgaliveColors.matterhorn,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [

                            const Padding(
                              padding: EdgeInsets.all(10),
                              child: FaIcon(
                                FontAwesomeIcons.bell,
                                color: OrgaliveColors.whiteSmoke,
                                size: 22,
                              ),
                            ),

                            ( notifications > 0 )
                            ? const Positioned(
                              top: 10,
                              right: 10,
                              child: Icon(
                                Icons.circle,
                                size: 10,
                                color: OrgaliveColors.greenDefault,
                              ),
                            )
                            : const Padding( padding: EdgeInsets.zero ),

                          ],
                        )
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment(50.0, 12.0),
            child: MainSettings(),
          ),
        ],
      ),
    ),
  );
}
