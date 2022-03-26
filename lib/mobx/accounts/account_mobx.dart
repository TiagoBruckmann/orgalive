// pacotes nativos do flutter
import 'package:flutter/material.dart';
import 'dart:async';

// import dos modelos
import 'package:orgalive/model/core/styles/orgalive_colors.dart';
import 'package:orgalive/model/functions/accounts/account.dart';
import 'package:orgalive/model/model_categories.dart';
import 'package:orgalive/model/model_accounts.dart';

// import das telas
import 'package:orgalive/screens/widgets/message_widget.dart';
import 'package:orgalive/screens/home.dart';

// import dos pacotes
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:intl/intl.dart';
part 'account_mobx.g.dart';

class AccountMobx = _AccountMobx with _$AccountMobx;

// Store é utilizado para geracao de codigos automaticos
abstract class _AccountMobx with Store {

  @observable
  String userUid = "";

  @observable
  int screenActive = 1;

  @observable
  String category = "";

  @observable
  String accountId = "";

  @observable
  String oldValue = "";

  @observable
  String originAccountId = "";

  @observable
  String originOldValue = "";

  @observable
  DateTime daySelected = DateTime.now();

  @action
  setData( String userid, int screen ) {
    userUid = userid;
    screenActive = screen;
  }

  @action
  void setValue( ModelAccounts modelAccounts ) {
    accountId = modelAccounts.document!;
    oldValue = modelAccounts.value!;
  }

  @action
  void setOrigin( ModelAccounts modelAccounts ) {
    originAccountId = modelAccounts.document!;
    originOldValue = modelAccounts.value!;
  }

  @action
  void setDateSelected( DateTime? date ) => daySelected = date!;

  @action
  void setCategory( String value ) => category = value;

  // variaveis do banco
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // buscar as contas cadastradas do usuario
  @action
  Future<List<ModelAccounts>> getAccounts({ String? originDocumentId }) async {

    List<ModelAccounts> listAccounts = [];

    QuerySnapshot data;
    if ( originDocumentId == null ) {

      data = await _db.collection("accounts")
        .where("user_uid", isEqualTo: userUid)
        .get();

    } else {

      data = await _db.collection("accounts")
        .where("user_uid", isEqualTo: userUid)
        .where("document", isNotEqualTo: originDocumentId)
        .get();

    }

    List<ModelAccounts> list = [];

    for ( var item in data.docs ) {

      ModelAccounts modelAccounts = ModelAccounts(
        item["user_uid"],
        item["name"],
        item["value"],
        item["document"],
        item["default"],
      );

      list.add(modelAccounts);
    }

    listAccounts.addAll(list);

    return listAccounts;

  }

  // buscar todas as categorias de servicos
  @action
  Future<List<ModelCategories>> getCategories() async {

    List<ModelCategories> listCategories = [];

    var data = await _db.collection("categories").get();

    List<ModelCategories> list = [];

    for ( var item in data.docs ) {

      ModelCategories modelCategories = ModelCategories(
        item["uid"],
        item["name"],
        item["icon"],
        /*
        item["document"],
        item["default"],
        item["default"],
         */
      );

      list.add(modelCategories);
    }

    listCategories.addAll(list);

    return listCategories;

  }

  // faz o envio da imagem para o storage
  @action
  Future uploadImage( List<XFile> imageFileList  ) async {
    firebase_storage.UploadTask uploadTask;

    firebase_storage.Reference archive = firebase_storage
      .FirebaseStorage.instance
      .ref()
      .child("documents")
      .child(imageFileList[0].name);

    final metadata = firebase_storage.SettableMetadata(
      contentType: '${imageFileList[0].mimeType}',
      customMetadata: {'picked-file-path': imageFileList[0].path},
    );

    uploadTask = archive.putData(await imageFileList[0].readAsBytes(), metadata);

    return Future.value(uploadTask);
  }

  // salvar lancamento
  @action
  saveRelease( List<XFile>? imageFileList, String registerValue, String type, String description, context ) async {

    // salvar arquivo
    if ( imageFileList != null ) {
      uploadImage( imageFileList );
    }

    String valueFormatted = registerValue.replaceAll("R\$ ", "");
    num value = num.parse(registerValue.replaceAll("R\$ ", "").replaceAll(".", "").replaceAll(",", "."));

    DateTime now = DateTime.now();
    String dateNow = DateFormat('yyyyMMddkkmmss').format(now);

    int? status;
    if ( daySelected.month >= now.month && daySelected.day >= now.day ) {

      if ( daySelected.month > now.month ) {
        status = 0;
      } else if ( daySelected.month == now.month && daySelected.day > now.day ) {
        status = 0;
      } else if ( daySelected.month == now.month && daySelected.day == now.day ) {
        status = 1;
      }
    } else {
      status = 1;
    }

    var data = {
      "user_uid": userUid,
      "document": dateNow,
      "value": valueFormatted,
      "description": description,
      "type": type,
      "category": category,
      "account_id": accountId,
      "date": daySelected.toString(),
      "status": status,
    };

    await _db.collection("releases").doc(dateNow).set(data);

    updateAccount( value, context );
  }

  // atualizar o valor da conta
  @action
  updateAccount( num value, context ) async {

    num valueParse = num.parse(oldValue.replaceAll(".", "").replaceAll(",", "."));

    String newValue;
    if ( screenActive == 2 ) {
      newValue = AccountFunction().sumValue(valueParse, value);
    } else {
      newValue = AccountFunction().decrementValue(valueParse, value);
    }

    var data = {
      "value": newValue,
    };

    _db.collection("accounts").doc(accountId).update(data);

    if ( originAccountId.isNotEmpty ) {
      _db.collection("accounts").doc(originAccountId).update(data);
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (builder) => const Home(
          selected: 0,
        ),
      ),
      (route) => false,
    );

    CustomSnackBar(
      context,
      ( screenActive == 1 )
      ? "Despesa cadastrada com sucesso"
      : ( screenActive == 2 )
      ? "Lucro cadastrado com sucesso"
      : "Transferência cadastrada com sucesso",
      OrgaliveColors.greenDefault,
    );

  }

}