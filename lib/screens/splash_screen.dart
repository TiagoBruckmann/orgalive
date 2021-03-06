// pacotes nativos flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

// import dos pacotes
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// import dos modelos
import 'package:orgalive/core/routes/shared_routes.dart';
import 'package:orgalive/core/styles/app_images.dart';

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

        SharedRoutes().goToHomeRemoveUntil(context);

      } else {
        SharedRoutes().goToInfo(context);
      }

    } else {
      SharedRoutes().goToInfo(context);
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
