// imports nativos
import 'dart:async';

// import dos pacotes
import 'package:cloud_firestore/cloud_firestore.dart';

// import dos modelos
import 'package:orgalive/model/model_categories.dart';

class SpendingBloc {

  final List<ModelCategories> _listCategories = [];
  List<ModelCategories> get listCategories => _listCategories;

  final _blocController = StreamController<List>();

  Stream<List> get listen => _blocController.stream;

  // variaveis do banco
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool isLoading =  true;

  getCategories() async {

    if ( _listCategories.isEmpty && isLoading == true ) {

      dynamic data = await _db.collection("categories").get();

      for ( dynamic item in data.docs ) {

        ModelCategories modelCategories = ModelCategories(
          item["uid"],
          item["name"],
          item["selected"],
          item["value_spending"],
          item["value_limit"],
          double.parse(item["percentage"].toString()),
        );

        add(modelCategories);
      }

      isLoading = false;

    }

    return _listCategories;
  }

  void add( ModelCategories modelCategories ) {

    _listCategories.add(modelCategories);
    return _blocController.sink.add(listCategories);
  }

  clear() {
    isLoading = true;
    _listCategories.clear();
    return _blocController.sink.add(listCategories);
  }

  closeStream() {
    clear();
    _blocController.close();
  }
}