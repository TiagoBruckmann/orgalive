// imports nativos
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
part 'users_mobx.g.dart';

class UsersMobx = _UsersMobx with _$UsersMobx;

abstract class _UsersMobx with Store {

  @observable
  String timeOfDay = "Bom dia";

  @observable
  String user = "";

  @observable
  String photo = "";

  @observable
  String userUid = "";

  @action
  getInfo() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? userData = auth.currentUser;

    String? displayName;
    String? photoUrl;

    // variaveis do banco
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    if ( userData!.displayName == null ) {

      var data = await _db.collection("users").where("uid", isEqualTo: userData.uid).get();

      for ( var item in data.docs ) {
        displayName = item["name"];
        photoUrl = item["photo"];
      }

    } else {
      displayName = userData.displayName!;
      photoUrl = userData.photoURL!;
    }

    userUid = userData.uid;
    user = displayName!;
    photo = photoUrl!;

    final TimeOfDay currentTime = TimeOfDay.now();

    if ( currentTime.hour >= 06 && currentTime.hour < 12 ) {
      timeOfDay = "Bom dia";
    } else if ( currentTime.hour >= 12 && currentTime.hour < 18 ) {
      timeOfDay = "Boa tarde";
    } else {
      timeOfDay = "Boa noite";
    }
  }

}