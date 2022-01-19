// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:calendar_timeline/calendar_timeline.dart';

// import dos modelos
import 'package:orgalive/model/core/firebase/model_firebase.dart';
import 'package:orgalive/model/core/styles/orgalive_colors.dart';

// import das telas
import 'package:orgalive/screens/releases/widgets/card_date_widget.dart';

class Releases extends StatefulWidget {
  const Releases({Key? key}) : super(key: key);

  @override
  _ReleasesState createState() => _ReleasesState();
}

class _ReleasesState extends State<Releases> {
  // variaveis da tela
  final DateTime _currentYear = DateTime.now();

  @override
  void initState() {
    super.initState();
    Analytics().sendScreen("Releases");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lançamentos"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CalendarTimeline(
              initialDate: _currentYear,
              firstDate: DateTime(2021, 12, 06),
              lastDate: DateTime(2023, 12, 06),
              leftMargin: 16,
              onDateSelected: (date) => print(date),
              monthColor: OrgaliveColors.silver,
              dayColor: OrgaliveColors.bossanova,
              activeDayColor: OrgaliveColors.silver,
              activeBackgroundDayColor: OrgaliveColors.bossanova,
              dotsColor: OrgaliveColors.bossanova,
              locale: 'pt_BR',
            ),

            // dias de lançamento de valores
            const CardDateWidget(
              title: "05 de Dezembro",
            ),

            // lista dos bagulho
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: OrgaliveColors.greenDefault,
                radius: 22,
                child: Icon(
                  Icons.star,
                  color: OrgaliveColors.whiteSmoke,
                  size: 25,
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Salário RFS",
                    style: TextStyle(
                      color: OrgaliveColors.whiteSmoke,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "R\$ 1.724,00",
                    style: TextStyle(
                      color: OrgaliveColors.greenDefault,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Conta inicial",
                    style: TextStyle(
                      color: OrgaliveColors.bossanova,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "Não recebido",
                    style: TextStyle(
                      color: OrgaliveColors.bossanova,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            // dias de lançamento de valores
            const CardDateWidget(
              title: "06 de Dezembro",
            ),

            // lista dos bagulho
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: OrgaliveColors.darkGray,
                radius: 22,
                child: Icon(
                  Icons.account_balance,
                  color: OrgaliveColors.bossanova,
                  size: 25,
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Contas de casa",
                    style: TextStyle(
                      color: OrgaliveColors.whiteSmoke,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "- R\$ 300,00",
                    style: TextStyle(
                      color: OrgaliveColors.redDefault,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Conta inicial",
                    style: TextStyle(
                      color: OrgaliveColors.bossanova,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "pago",
                    style: TextStyle(
                      color: OrgaliveColors.bossanova,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
