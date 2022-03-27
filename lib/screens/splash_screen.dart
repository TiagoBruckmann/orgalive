// pacotes nativos flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

// import dos pacotes
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// import dos modelos
import 'package:orgalive/model/core/styles/app_images.dart';

// import das telas
import 'package:orgalive/screens/login/info.dart';
import 'home.dart';

// gerenciadores de estado
import 'package:orgalive/mobx/connection/connection_mobx.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // gerenciadores de estado
  late ConnectionMobx _connectionMobx;

  _verifyUserLogged() async {

    if ( _connectionMobx.connectionStatus.toString() == "ConnectivityResult.wifi" || _connectionMobx.connectionStatus.toString() == "ConnectivityResult.mobile" ) {

      FirebaseAuth auth = FirebaseAuth.instance;
      User? userData = auth.currentUser;

      if( userData != null ) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (builder) => const Home(
              selected: 0,
            ),
          ),
        );

      } else {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (builder) => const Info(),
          ),
        );

      }

    } else {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (builder) => const Info(),
        ),
      );

    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _connectionMobx = Provider.of<ConnectionMobx>(context);

    await _connectionMobx.verifyConnection();
    _connectionMobx.connectivity.onConnectivityChanged.listen(_connectionMobx.updateConnectionStatus);

    Timer(const Duration(seconds: 3), () {
      _verifyUserLogged();
    });
  }

  @override
  Widget build(BuildContext context) {
    // função para bloquear o giro da tela
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      body: Container(
        // color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Image.asset(
            AppImages.logo2,
            width: 200,
          ),
        ),
      ),
    );
  }
}
