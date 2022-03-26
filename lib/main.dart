// imports nativos
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import dos pacotes
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:orgalive/mobx/accounts/account_mobx.dart';
import 'package:provider/provider.dart';

// import dos modelos
import 'package:orgalive/model/core/styles/orgalive_colors.dart';

// import das telas
import 'package:orgalive/screens/splash_screen.dart';

// gerenciadores de estado
import 'package:orgalive/mobx/connection/connection_mobx.dart';

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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FirebasePerformance.instance;

  // função para alterar a cor da barra de status
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: OrgaliveColors.greyDefault,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => ConnectionMobx(),
        ),
      ],
      child: MaterialApp(
        title: "Orgalive",
        theme: defaultTheme,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    )
  );
}