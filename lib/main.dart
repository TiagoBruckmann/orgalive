import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import dos pacotes
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';

// import dos modelos
import 'package:orgalive/Model/Core/styles/orgalive_colors.dart';

// import das telas
import 'package:orgalive/Screens/home.dart';

final ThemeData defaultTheme = ThemeData(
  primaryColor: OrgaliveColors.greyDefault,
  secondaryHeaderColor: OrgaliveColors.greenDefault,

  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ),
    backgroundColor: OrgaliveColors.greyDefault,
  ),

  scaffoldBackgroundColor: OrgaliveColors.greyBackground,


);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // função para alterar a cor da barra de status
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: OrgaliveColors.greyDefault,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // função para bloquear o giro da tela
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MaterialApp(
      title: "Orgalive",
      theme: defaultTheme,
      home: const Home(),
      debugShowCheckedModeBanner: false,
    ),
  );
}