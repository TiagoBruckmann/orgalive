// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:orgalive/Model/Core/styles/orgalive_colors.dart';

// import das telas
import 'package:orgalive/Screens/dashboard/setting_accounts.dart';

class MainSettings extends StatefulWidget {

  final String userUid;
  const MainSettings({ Key? key, required this.userUid }) : super(key: key);

  @override
  _MainSettingsState createState() => _MainSettingsState();
}

class _MainSettingsState extends State<MainSettings> {

  // variaveis da tela
  bool _valueVisible = false;

  // alterar a visibilidade do valor
  _changeVisibility() {
    if ( _valueVisible == false ) {
      setState(() {
        _valueVisible = true;
      });
    } else {
      setState(() {
        _valueVisible = false;
      });
    }
  }

  // gerenciar as contas
  _goToSettingAccounts() {

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 130, 16, 5),
      child: Card(
        color: OrgaliveColors.greyDefault,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular( 10 ),
        ),
        child: Column(
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
                    ( _valueVisible == false )
                    ? "R\$ 1.514,49"
                    : "R\$  - - - - - -",
                    style: const TextStyle(
                      color: OrgaliveColors.whiteSmoke,
                      fontSize: 20,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      _changeVisibility();
                    },
                    child: Icon(
                      ( _valueVisible == false )
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
              title: const Text(
                "Conta inicial",
                style: TextStyle(
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
                    ( _valueVisible == false )
                    ? "R\$ 1.514,49"
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
                    _goToSettingAccounts();
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
        ),
      ),
    );
  }
}
