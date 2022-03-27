// import dos modelos
import 'package:orgalive/model/core/styles/orgalive_colors.dart';
import 'package:orgalive/model/functions/releases/releases.dart';
import 'package:orgalive/model/model_release.dart';

// import das telas
import 'package:orgalive/screens/widgets/message_widget.dart';

// import dos pacotes
import 'package:mobx/mobx.dart';
part 'release_mobx.g.dart';

class ReleaseMobx = _ReleaseMobx with _$ReleaseMobx;

abstract class _ReleaseMobx with Store {

  @observable
  bool isLoading = true;

  ObservableList<ModelRelease> listReleases = ObservableList();

  @action
  void updLoading( bool value ) => isLoading = value;

  @action
  void setNew( ModelRelease modelRelease ) => listReleases.add(modelRelease);

  @action
  filterReleases( DateTime dateFilter, context ) {

    String day = ReleaseFunction().formatDate(dateFilter.day);
    String month = ReleaseFunction().formatDate(dateFilter.month);
    String date = "${dateFilter.year}$month$day";
    listReleases.retainWhere((items) => items.document!.contains(date));
    if ( listReleases.isEmpty ) {
      CustomSnackBar(context, "Não encontramos nenhum lançamento para o dia selecionado.", OrgaliveColors.redDefault);
      clear();
    }

    return listReleases;

  }

  @action
  void clear() {
    listReleases.clear();
    isLoading = true;
  }

}