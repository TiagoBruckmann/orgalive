// imports nativos
import 'dart:async';

// import dos pacotes
import 'package:cloud_firestore/cloud_firestore.dart';

// import dos modelos
import 'package:orgalive/core/functions/releases/releases.dart';
import 'package:orgalive/core/styles/orgalive_colors.dart';
import 'package:orgalive/model/model_release.dart';

// import das telas
import 'package:orgalive/screens/widgets/message_widget.dart';

class ReleaseBloc {

  final List<ModelRelease> _listReleases = [];
  List<ModelRelease> get listReleases => _listReleases;

  final _blocController = StreamController<List>();

  Stream<List> get listen => _blocController.stream;

  // variaveis do banco
  final DateTime _currentYear = DateTime.now();
  bool isLoading =  true;

  getReleases( String userUid ) async {

    final FirebaseFirestore _db = FirebaseFirestore.instance;

    String month = ReleaseFunction().formatDate(_currentYear.month);
    String date = "${_currentYear.year}$month";

    if ( listReleases.isEmpty && isLoading == true ) {

      var data = await _db.collection("releases")
          .where("user_uid", isEqualTo: userUid)
          .get();

      for ( var item in data.docs ) {

        if ( item["document"].toString().contains(date) ) {

          ModelRelease modelRelease = ModelRelease(
            item["account_id"],
            item["category"],
            ReleaseFunction().formatMonth(item["date"]),
            item["description"],
            item["document"],
            item["status"],
            item["type"],
            item["user_uid"],
            item["value"],
          );

          add(modelRelease);
        }
      }
      updLoading(false);
    }
    return _listReleases;
  }

  filterReleases( DateTime dateFilter, context ) async {

    String day = ReleaseFunction().formatDate(dateFilter.day);
    String month = ReleaseFunction().formatDate(dateFilter.month);
    String date = "${dateFilter.year}$month$day";
    listReleases.retainWhere((items) => items.document.contains(date));
    if ( listReleases.isEmpty ) {
      CustomSnackBar(context, "Não encontramos nenhum lançamento para o dia selecionado.", OrgaliveColors.redDefault);
      clear();
    }

    return listReleases;
  }

  void add( ModelRelease modelRelease ) {

    _listReleases.add(modelRelease);
    return _blocController.sink.add(listReleases);
  }

  void updLoading( bool value ) => isLoading = value;

  clear() {
    isLoading = true;
    _listReleases.clear();
    return _blocController.sink.add(listReleases);
  }

  closeStream() {
    clear();
    _blocController.close();
  }
}