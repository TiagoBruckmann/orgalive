// import dos modelos
import 'package:orgalive/model/core/styles/orgalive_colors.dart';
import 'package:orgalive/model/model_accounts.dart';

// import dos pacotes
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:orgalive/screens/widgets/message_widget.dart';
part 'default_account_mobx.g.dart';

class DefaultAccountMobx = _DefaultAccountMobx with _$DefaultAccountMobx;

abstract class _DefaultAccountMobx with Store {

  ObservableList<ModelAccounts> listAccounts = ObservableList();

  @observable
  bool isLoading = true;

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

  @action
  void updLoading( bool value ) => isLoading = value;

  @action
  void updateVale( String newValue, String document, var _db, context ) {
    var data = {
      "value": newValue,
    };
    _db.collection("accounts").doc(document).update(data);
    CustomSnackBar( context, "Conta atualizada com sucesso", OrgaliveColors.greenDefault );
    clear();
  }

  @action
  void setNew( ModelAccounts modelAccounts ) {
    value = modelAccounts.value!;
    listAccounts.add(modelAccounts);
  }

  @action
  void clear() {
    value = "";
    listAccounts.clear();
    isLoading = true;
  }

}