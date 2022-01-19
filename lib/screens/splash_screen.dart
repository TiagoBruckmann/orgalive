// pacotes nativos flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

// import dos pacotes
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import dos modelos
import 'package:orgalive/model/core/styles/app_images.dart';

// import das telas
import 'package:orgalive/screens/login/info.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // conexao com a internet
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

  // verificar conexão com a internet
  Future<void> verifyConnection() async {

    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      FirebaseCrashlytics.instance.log(e.toString());
      return;
    }

    return _updateConnectionStatus(result);

  }

  // atualizar o status da conexao
  Future<void> _updateConnectionStatus( ConnectivityResult result ) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(const Duration(seconds: 3), () {
      _verifyUserLoged();
    });
  }

  _verifyUserLoged() async {

    if ( _connectionStatus.toString() == "ConnectivityResult.wifi" || _connectionStatus.toString() == "ConnectivityResult.mobile" ) {

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
              builder: (builder) => const Info()
          ),
        );

      }

    } else {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (builder) => const Info()
        ),
      );

    }
  }

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
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
            AppImages.logo,
            width: 200,
          ),
        ),
      ),
    );
  }
}
