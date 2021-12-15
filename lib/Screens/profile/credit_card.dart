// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import dos modelos
import 'package:orgalive/Model/Core/styles/orgalive_colors.dart';

class CreditCard extends StatefulWidget {
  const CreditCard({Key? key}) : super(key: key);

  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cartões de crédito"),
      ),

      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {

          return Card(
            color: OrgaliveColors.greyDefault,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular( 10 ),
            ),
            child: ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.solidCreditCard,
                color: OrgaliveColors.darkGray,
                size: 25,
              ),
              title: const Text(
                "6393 **** **** 3166",
                style: TextStyle(
                  color: OrgaliveColors.whiteSmoke,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [

                  Text.rich(
                    TextSpan(
                      text: "Validade: ",
                      style: TextStyle(
                        color: OrgaliveColors.silver,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                          text: "10/29",
                          style: TextStyle(
                            color: OrgaliveColors.whiteSmoke,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text.rich(
                    TextSpan(
                      text: "CVV: ",
                      style: TextStyle(
                        color: OrgaliveColors.silver,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                          text: "300",
                          style: TextStyle(
                            color: OrgaliveColors.whiteSmoke,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          );

        },
      ),
    );
  }
}
