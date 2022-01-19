// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import dos modelos
import 'package:orgalive/model/core/styles/orgalive_colors.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notificações"),
      ),

      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {

          return Column(
            children: [

              ( index == 0 )
              ? const Padding(
                padding: EdgeInsets.only( left: 16, top: 16, ),
              )
              : const Padding(padding: EdgeInsets.zero),

              Padding(
                padding: const EdgeInsets.symmetric( horizontal: 10 ),
                child: Card(
                  color: OrgaliveColors.greyDefault,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular( 10 ),
                  ),
                  child: const ListTile(
                    // no lugar do icone vai a logo do app
                    leading: CircleAvatar(
                      backgroundColor: OrgaliveColors.darkGray,
                      radius: 18,
                      child: FaIcon(
                        FontAwesomeIcons.bell,
                        color: OrgaliveColors.bossanova,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      "Mensagem da notificação",
                      style: TextStyle(
                        color: OrgaliveColors.whiteSmoke,
                        // fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

            ],
          );
        },
      ),
    );
  }
}
