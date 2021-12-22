// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import dos modelos
import 'package:orgalive/Model/Core/firebase/model_firebase.dart';
import 'package:orgalive/Model/Core/styles/orgalive_colors.dart';

// import das telas
import 'package:orgalive/Screens/dashboard/categories_essentials.dart';
import 'package:orgalive/Screens/dashboard/widget/app_bar_widget.dart';
import 'package:orgalive/Screens/dashboard/personalize.dart';
import 'package:orgalive/Screens/dashboard/more_info.dart';
import 'package:orgalive/Screens/home.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  String _timeOfDay = "Bom dia";
  final int _notifications = 1;
  String _user = "";
  String _photo = "";
  String _userUid = "";

  // busca a hora atual
  _getInfos() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? userData = auth.currentUser;

    _userUid = userData!.uid;
    _user = userData.displayName!;
    _photo = userData.photoURL!;

    final TimeOfDay currentTime = TimeOfDay.now();

    if ( currentTime.hour >= 06 && currentTime.hour < 12 ) {
      _timeOfDay = "Bom dia";
    } else if ( currentTime.hour >= 12 && currentTime.hour < 18 ) {
      _timeOfDay = "Boa tarde";
    } else {
      _timeOfDay = "Boa noite";
    }
  }

  // novo limite de gasto
  _goToNewSpending() {
    // vai para a tela SpendingLimits()
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (builder) => const Home(
          selected: 4,
        ),
      ),
    );
  }

  // mais informações
  _goToMoreInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => const MoreInfo()
      ),
    );
  }

  // categorias
  _goToCategories() {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => const CategoriesEssentials(),
      )
    );
  }

  // personalizar a exibição
  _personalize() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => const Personalize(),
      )
    );
  }

  @override
  void initState() {
    super.initState();
    _getInfos();
    Analytics().sendScreen("Dashboard");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        userUid: _userUid,
        user: _user,
        photo: _photo,
        timeOfDay: _timeOfDay,
        notifications: _notifications,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
        child: Column(
          children: [

            // limite de gastos
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Card(
                color: OrgaliveColors.greyDefault,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular( 10 ),
                ),
                child: Column(
                  children: [

                    // saldo geral
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        const Padding(
                          padding: EdgeInsets.only( left: 16 ),
                          child: Text(
                            "Limite de gastos",
                            style: TextStyle(
                              color: OrgaliveColors.whiteSmoke,
                              fontSize: 20,
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            _goToNewSpending();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only( right: 16, top: 10, ),
                            child: Card(
                              color: OrgaliveColors.greenDefault,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular( 50 ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: FaIcon(
                                  FontAwesomeIcons.plus,
                                  color: OrgaliveColors.greyDefault,
                                  size: 18,
                                ),
                              ),

                            ),
                          ),
                        ),

                      ],
                    ),

                    // nome do gasto
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: OrgaliveColors.darkGray,
                        radius: 20,
                        child: Icon(
                          Icons.home,
                          color: OrgaliveColors.bossanova,
                          size: 25,
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [

                          // nome do gasto
                          Text(
                            "Casa",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),

                          // valor estimado
                          Text(
                            "R\$ 300,00",
                            style: TextStyle(
                              color: OrgaliveColors.silver,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),

                        ],
                      ),
                      subtitle: const LinearProgressIndicator(
                        backgroundColor: OrgaliveColors.silver,
                        color: OrgaliveColors.fuchsia,
                        value: 1,
                      ),
                    ),

                    const Divider(
                      color: OrgaliveColors.bossanova,
                      thickness: 2,
                      height: 10,
                      indent: 16,
                      endIndent: 16,
                    ),

                    // nome do gasto
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: OrgaliveColors.darkGray,
                        radius: 20,
                        child: FaIcon(
                          FontAwesomeIcons.carAlt,
                          color: OrgaliveColors.bossanova,
                          size: 25,
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [

                          // nome do gasto
                          Text(
                            "Transporte",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),

                          // valor estimado
                          Text(
                            "R\$ 50,00",
                            style: TextStyle(
                              color: OrgaliveColors.silver,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),

                        ],
                      ),
                      subtitle: const LinearProgressIndicator(
                        backgroundColor: OrgaliveColors.silver,
                        color: OrgaliveColors.fuchsia,
                        value: 0.5,
                      ),
                    ),

                  ],
                ),
              ),
            ),

            // equilibrio financeiro
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Card(
                color: OrgaliveColors.greyDefault,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular( 10 ),
                ),
                child: Column(
                  children: [

                    // saldo geral
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        const Padding(
                          padding: EdgeInsets.only( left: 16, top: 16 ),
                          child: Text(
                            "Equilibrio financeiro",
                            style: TextStyle(
                              color: OrgaliveColors.whiteSmoke,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            _goToMoreInfo();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only( right: 16, top: 10, ),
                            child: Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only( right: 5 ),
                                  child: FaIcon(
                                    FontAwesomeIcons.infoCircle,
                                    color: OrgaliveColors.darkGray,
                                    size: 15,
                                  ),
                                ),

                                Text(
                                  "Saiba mais",
                                  style: TextStyle(
                                    color: OrgaliveColors.silver,
                                    fontSize: 12,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),

                      ],
                    ),

                    // gastos essenciais
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [

                        Padding(
                          padding: EdgeInsets.only( top: 10, left: 16, ),
                          child: Text(
                            "Gastos essenciais",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // gastos essenciais
                    ListTile(
                      title: const LinearProgressIndicator(
                        minHeight: 8,
                        backgroundColor: OrgaliveColors.silver,
                        color: OrgaliveColors.greenDefault,
                        value: 0.35,
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [

                          Text(
                            "Limite recomendado de R\$ 862,00",
                            style: TextStyle(
                              color: OrgaliveColors.silver,
                              fontSize: 14,
                            ),
                          ),

                          Text(
                            "R\$ 300,00",
                            style: TextStyle(
                              color: OrgaliveColors.whiteSmoke,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),

                        ],
                      )
                    ),

                    const Divider(
                      color: OrgaliveColors.bossanova,
                      thickness: 2,
                      height: 10,
                      indent: 16,
                      endIndent: 16,
                    ),

                    // gastos não essenciais
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [

                        Padding(
                          padding: EdgeInsets.only( top: 10, left: 16, ),
                          child: Text(
                            "Gastos não essenciais",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // gastos não essenciais
                    ListTile(
                      title: const LinearProgressIndicator(
                        backgroundColor: OrgaliveColors.silver,
                        color: OrgaliveColors.redDefault,
                        minHeight: 8,
                        value: 1,
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [

                          Text(
                            "Limite recomendado de R\$ 517,20",
                            style: TextStyle(
                              color: OrgaliveColors.silver,
                              fontSize: 14,
                            ),
                          ),

                          Text(
                            "R\$ 1.026,88",
                            style: TextStyle(
                              color: OrgaliveColors.whiteSmoke,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),

                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only( top: 10, bottom: 20 ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: OrgaliveColors.greenDefault,
                          padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          _goToCategories();
                        },
                        child: const Text(
                          "Redefinir categorias essenciais",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                _personalize();
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 32,
                child: Card(
                  color: OrgaliveColors.greyDefault,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular( 10 ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only( top: 15, bottom: 15 ),
                    child: Text(
                      "Personalizar",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: OrgaliveColors.silver,
                        fontSize: 18,
                      ),
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
