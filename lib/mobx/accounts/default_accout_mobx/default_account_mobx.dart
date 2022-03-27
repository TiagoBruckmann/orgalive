// import dos pacotes
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
part 'default_account_mobx.g.dart';

class DefaultAccountMobx = _DefaultAccountMobx with _$DefaultAccountMobx;

abstract class _DefaultAccountMobx with Store {

  @observable
  String accountId = "";

  @observable
  String account = "";

  @observable
  String value = "";

  @observable
  bool valueVisible = false;

  @action
  void setData( var data ) {
    accountId = data["document"];
    account = data["name"];
    value = data["value"];
    valueVisible = data["value_visible"];
  }

  @action
  void updVisible() {

    // variaveis do banco
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    var data = {
      "value_visible": valueVisible = !valueVisible,
    };

    _db.collection("accounts").doc(accountId).update(data);
  }

}