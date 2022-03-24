// pacotes nativos do flutter
import 'package:flutter/services.dart';
import 'dart:async';

// import dos pacotes
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mobx/mobx.dart';
part 'connection_mobx.g.dart';

class ConnectionMobx = _ConnectionMobx with _$ConnectionMobx;

// Store é utilizado para geracao de codigos automaticos
abstract class _ConnectionMobx with Store {

  @observable
  ConnectivityResult connectionStatus = ConnectivityResult.none;

  @observable
  Connectivity connectivity = Connectivity();

  @action
  Future<void> verifyConnection() async {

    ConnectivityResult result;

    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      FirebaseCrashlytics.instance.log(e.toString());
      return;
    }

    return updateConnectionStatus(result);

  }

  @action
  Future<void> updateConnectionStatus( ConnectivityResult result ) async {
    connectionStatus = result;
  }
}