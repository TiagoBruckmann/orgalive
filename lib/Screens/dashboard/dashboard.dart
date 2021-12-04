// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos modelos
import 'package:orgalive/Model/Core/orgalive_colors.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  _goToSettingAccounts() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Olá, Tiago"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Card(
                color: OrgaliveColors.greyDefault,
                child: Column(
                  children: [

                    // saldo getal
                    const ListTile(
                      title: Text(
                        "Saldo geral",
                        style: TextStyle(
                          color: OrgaliveColors.silver,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        "R\$ 1.514,49",
                        style: TextStyle(
                          color: OrgaliveColors.whiteSmoke,
                          fontSize: 20,
                        ),
                      ),
                    ),

                    const Text(
                      "Minhas contas",
                      style: TextStyle(
                        color: OrgaliveColors.whiteSmoke,
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                      ),
                    ),

                    // contas
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: OrgaliveColors.darkGray,
                        radius: 40,
                        child: Icon(
                          Icons.account_balance,
                          size: 16,
                        ),
                      ),
                      title: const Text(
                        "Conta inicial",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Row(
                        children: const [

                          Text(
                            "Outros",
                            style: TextStyle(
                              color: OrgaliveColors.silver,
                              fontSize: 14,
                            ),
                          ),

                          Text(
                            "R\$ 1.514,49",
                            style: TextStyle(
                              color: OrgaliveColors.blueDefault,
                              fontSize: 18,
                            ),
                          ),

                        ],
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: OrgaliveColors.greenDefault,
                        padding: const EdgeInsets.fromLTRB(36, 16, 36, 16),
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
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
