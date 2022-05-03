// imports nativos
import 'dart:async';

// import dos pacotes
import 'package:cloud_firestore/cloud_firestore.dart';

// import dos modelos
import 'package:orgalive/model/model_credit_card.dart';

class CreditCardBloc {

  final List<ModelCreditCard> _listCredits = [];
  List<ModelCreditCard> get listCredits => _listCredits;

  final _blocController = StreamController<List>();

  Stream<List> get listen => _blocController.stream;

  // variaveis da tela
  bool isLoading =  true;

  getCards( String userUid ) async {

    final FirebaseFirestore _db = FirebaseFirestore.instance;

    if ( _listCredits.isEmpty && isLoading == true ) {

      dynamic data = await _db.collection("credit_card")
          .where("user_uid", isEqualTo: userUid)
          .get();

      for ( dynamic item in data.docs ) {

        ModelCreditCard modelCreditCard = ModelCreditCard(
            item["type"],
            item["number"],
            item["valid"],
            item["cvv"],
            item["user_uid"],
            item["document"]
        );

        add(modelCreditCard);
      }
      isLoading = false;

    }

    return _listCredits;
  }

  void add( ModelCreditCard modelCreditCard ) {

    _listCredits.add(modelCreditCard);
    return _blocController.sink.add(listCredits);
  }

  void updLoading( bool value ) => isLoading = value;

  clear() {
    isLoading = true;
    _listCredits.clear();
    return _blocController.sink.add(listCredits);
  }

  closeStream() {
    clear();
    _blocController.close();
  }
}