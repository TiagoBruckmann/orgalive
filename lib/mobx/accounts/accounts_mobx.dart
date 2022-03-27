// import dos modelos
import 'package:orgalive/model/model_accounts.dart';

// import dos pacotes
import 'package:mobx/mobx.dart';
part 'accounts_mobx.g.dart';

class AccountsMobx = _AccountsMobx with _$AccountsMobx;

abstract class _AccountsMobx with Store {

  @observable
  bool isLoading = true;

  ObservableList<ModelAccounts> listAccounts = ObservableList();

  @action
  void updLoading( bool value ) => isLoading = value;

  @action
  void setNew( ModelAccounts modelAccounts ) => listAccounts.add(modelAccounts);

  @action
  void clear() {
    listAccounts.clear();
    isLoading = true;
  }

}