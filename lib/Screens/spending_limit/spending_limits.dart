// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import dos modelos
import 'package:orgalive/Screens/spending_limit/detail_spending.dart';
import 'package:orgalive/Model/Core/firebase/model_firebase.dart';
import 'package:orgalive/Model/Core/styles/orgalive_colors.dart';

class SpendingLimits extends StatefulWidget {
  const SpendingLimits({Key? key}) : super(key: key);

  @override
  _SpendingLimitsState createState() => _SpendingLimitsState();
}

class _SpendingLimitsState extends State<SpendingLimits> {

  _goTodetailSpending( int id, String spendingName ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => DetailSpending(id: id, name: spendingName)
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Analytics().sendScreen("spending-limits");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Limite de gastos"),
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: ( context, index ) {
          
          return Container(
            padding: const EdgeInsets.fromLTRB(2, 10, 2, 0),
            child: Row(
              children: [

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _goTodetailSpending( 1, "Casa");
                    },
                    child: Card(
                      color: OrgaliveColors.greyDefault,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular( 10 ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 16, 10),
                        child: Column(
                          children: [

                            // categoria
                            const ListTile(
                              leading: CircleAvatar(
                                backgroundColor: OrgaliveColors.darkGray,
                                radius: 17,
                                child: FaIcon(
                                  FontAwesomeIcons.home,
                                  color: OrgaliveColors.bossanova,
                                  size: 14,
                                ),
                              ),
                              title: Text(
                                "Casa",
                                style: TextStyle(
                                  color: OrgaliveColors.whiteSmoke,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),

                            const Divider(
                              color: OrgaliveColors.bossanova,
                              height: 5,
                              indent: 10,
                              endIndent: 10,
                            ),

                            // quantidade gasta
                            Row(
                              children: const [

                                Padding(
                                  padding: EdgeInsets.only( left: 10, top: 10 ),
                                  child: Text(
                                    "Disponível",
                                    style: TextStyle(
                                      color: OrgaliveColors.silver,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),

                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [

                                Padding(
                                  padding: EdgeInsets.symmetric( horizontal: 10, vertical: 10 ),
                                  child: Text.rich(
                                    TextSpan(
                                      text: "R\$ 0,00",
                                      style: TextStyle(
                                        color: OrgaliveColors.whiteSmoke,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "/R\$ 300,00",
                                          style: TextStyle(
                                            color: OrgaliveColors.silver,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),

                            const Divider(
                              color: OrgaliveColors.bossanova,
                              height: 10,
                              indent: 10,
                              endIndent: 10,
                            ),

                            // cartao e porcentagem gasta
                            Row(
                              children: [

                                Card(
                                  color: Colors.greenAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular( 4 ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric( vertical: 5, horizontal: 10 ),
                                    child: Row(
                                      children: const [

                                        FaIcon(
                                          FontAwesomeIcons.caretDown,
                                          color: OrgaliveColors.greenDefault,
                                          size: 15,
                                        ),

                                        Padding(
                                          padding: EdgeInsets.only( left: 5 ),
                                          child: Text(
                                            "0.00%",
                                            style: TextStyle(
                                              color: OrgaliveColors.greenDefault,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),

                                const Text(
                                  "Comparado ao mês anterior",
                                  style: TextStyle(
                                    color: OrgaliveColors.whiteSmoke,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),

                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                /*
                // lista vertical que fica na lateral direita
                const VerticalDivider(
                  indent: 10,
                  endIndent: 10,
                  color: OrgaliveColors.yellowDefault,
                  // thickness: 15,
                  width: 25,
                ),
                */

              ],
            ),
          );
        },
      ),
    );
  }
}