// pacotes nativos flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import das telas
import 'package:orgalive/screens/spending_limit/spending_limits.dart';
import 'package:orgalive/screens/releases/future_releases.dart';
import 'package:orgalive/screens/dashboard/dashboard.dart';
import 'package:orgalive/screens/releases/releases.dart';
import 'package:orgalive/screens/reports/reports.dart';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// import dos modelos
import 'package:orgalive/model/core/styles/orgalive_colors.dart';

class Home extends StatefulWidget {

  final int selected;
  const Home({ Key? key, required this.selected }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // controlar abas
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = const [
    Dashboard(),
    Releases(),
    FutureReleases(),
    Reports(),
    SpendingLimits(),
  ];

  // redireciona para a tela desejada
  _redirect() {

    if ( widget.selected != 0 ) {

      setState(() {
        _selectedIndex = widget.selected;
      });

    }
  }

  @override
  void initState() {
    super.initState();
    _redirect();
  }

  @override
  Widget build(BuildContext context) {
    // função para bloquear o giro da tela
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      // botões de navegação inferior
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: OrgaliveColors.greyDefault,
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: Colors.black.withOpacity(.1),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 6,
            ),
            child: GNav(
              rippleColor: OrgaliveColors.greyDefault,
              hoverColor: OrgaliveColors.greyDefault,
              gap: 5,
              iconSize: 23,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              duration: const Duration(milliseconds: 600),
              tabBackgroundColor: OrgaliveColors.greyDefault,
              tabs: [
                // dashboard
                GButton(
                  iconActiveColor: Theme.of(context).secondaryHeaderColor,
                  iconColor: OrgaliveColors.silver,
                  icon: Icons.home,
                ),

                // lancamentos futuros
                GButton(
                  iconActiveColor: Theme.of(context).secondaryHeaderColor,
                  iconColor: OrgaliveColors.silver,
                  icon: FontAwesomeIcons.exchangeAlt,
                ),

                // lancamentos
                GButton(
                  iconActiveColor: Theme.of(context).secondaryHeaderColor,
                  iconColor: OrgaliveColors.silver,
                  icon: FontAwesomeIcons.plus,
                ),

                // relatorios
                GButton(
                  iconActiveColor: Theme.of(context).secondaryHeaderColor,
                  iconColor: OrgaliveColors.silver,
                  icon: Icons.receipt_rounded,
                ),

                // limite de gastos
                GButton(
                  iconActiveColor: Theme.of(context).secondaryHeaderColor,
                  iconColor: OrgaliveColors.silver,
                  icon: Icons.track_changes_outlined,
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}