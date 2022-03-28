// imports nativos do flutter
import 'package:flutter/material.dart';
import 'dart:async';

// import dos modelos
import 'package:orgalive/model/core/styles/orgalive_colors.dart';
import 'package:orgalive/model/functions/releases/releases.dart';
import 'package:orgalive/model/model_categories.dart';
import 'package:orgalive/model/model_accounts.dart';

// import dos pacotes
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// import das telas
import 'package:orgalive/screens/widgets/message_widget.dart';
import 'package:orgalive/screens/home.dart';

class AccountFunction {

  // variaveis do banco
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  decrementValue( num oldValue, num newValue ) {
    num value = oldValue - newValue;
    double valueReplaced = double.parse(value.toString());
    final MoneyMaskedTextController _finalValue = MoneyMaskedTextController( thousandSeparator: '.', decimalSeparator: ',', initialValue: valueReplaced );
    return _finalValue.text;
  }

  sumValue( num oldValue, num newValue ) {
    num value = oldValue + newValue;
    double valueReplaced = double.parse(value.toString());
    final MoneyMaskedTextController _finalValue = MoneyMaskedTextController( thousandSeparator: '.', decimalSeparator: ',', initialValue: valueReplaced );
    return _finalValue.text;
  }

  Future<List<ModelAccounts>> getAccounts(String userUid, String? originDocumentId ) async {

    List<ModelAccounts> listAccounts = [];

    QuerySnapshot data;
    if ( originDocumentId == null ) {

      data = await _db.collection("accounts")
        .where("user_uid", isEqualTo: userUid)
        .get();

    } else {

      data = await _db.collection("accounts")
        .where("document", isNotEqualTo: originDocumentId)
        // .where("user_uid", isEqualTo: userUid)
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
  Future<List<ModelCategories>> getCategories() async {

    List<ModelCategories> listCategories = [];

    var data = await _db.collection("categories").get();

    List<ModelCategories> list = [];

    for ( var item in data.docs ) {

      ModelCategories modelCategories = ModelCategories(
        item["icon"],
        item["name"],
        item["uid"],
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
  saveRelease(
    String userUid, String category, String oldValue, int screenActive,
    String accountId, List<XFile>? imageFileList, String registerValue,
    String type, String description, DateTime daySelected, context,
    String nameFixed, String nameInstallments, String? originAccountId, String? originValue,
  ) async {

    // salvar arquivo
    if ( imageFileList != null ) {
      uploadImage( imageFileList );
    }

    String valueFormatted = registerValue.replaceAll("R\$ ", "");
    num value = num.parse(registerValue.replaceAll("R\$ ", "").replaceAll(".", "").replaceAll(",", "."));

    DateTime now = DateTime.now();
    String dateDocument = DateFormat('yyyyMMddkkmmss').format(daySelected);

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
      "document": dateDocument,
      "value": valueFormatted,
      "description": description,
      "type": type,
      "category": category,
      "account_id": accountId,
      "date": daySelected.toString(),
      "status": status,
    };

    await _db.collection("releases").doc(dateDocument).set(data);

    futureInstallments(
      nameFixed,
      daySelected,
      userUid,
      valueFormatted,
      description,
      type,
      category,
      accountId,
      nameInstallments,
    );

    updateAccount( value, oldValue, screenActive, accountId, context, originAccountId, originValue );
  }

  futureInstallments(
      String nameFixed, DateTime daySelected, String userUid, String valueFormatted,
      String description, String type, String category, String accountId, String nameInstallments,
  ) async {

    if ( nameFixed.isNotEmpty ) {

      int day = daySelected.day;
      int month = daySelected.month;
      int year = daySelected.year;
      while ( year <= 2023 && month < 12 ) {

        String dateSchedule;
        DateTime? dateFormatted;
        switch( nameFixed ) {
          case "Mensal":
            month = month + 1;
            break;
          case "Bimestral":
            month = month + 2;
            break;
          case "Trimestral":
            month = month + 3;
            break;
          case "Semestral":
            month = month + 6;
            break;
          case "Anual":
            month = month + 12;
            break;
        }

        if ( month > 12 ) {
          year = year + 1;
        }
        month = ReleaseFunction().calculateMonth(month);

        if ( month < 10 ) {
          dateFormatted = DateTime.parse("$year-0$month-$day 00:00:00.000");
        } else {
          dateFormatted = DateTime.parse("$year-$month-$day 00:00:00.000");
        }

        dateSchedule = DateFormat('yyyyMMddkkmmss').format(dateFormatted);

        var dataScheduled = {
          "user_uid": userUid,
          "document": dateSchedule,
          "value": valueFormatted,
          "description": description,
          "type": type,
          "category": category,
          "account_id": accountId,
          "date": dateFormatted.toString(),
          "status": 0,
        };

        await _db.collection("releases").doc(dateSchedule).set(dataScheduled);

      }

    } else if ( nameInstallments.isNotEmpty ) {

      int day = daySelected.day;
      int month = daySelected.month;
      int year = daySelected.year;

      int installment;
      if ( nameInstallments.contains(" Ano(s)") ) {
        int years = int.parse(nameInstallments.replaceAll(" Ano(s)", ""));
        installment = years * 12;
      } else if ( nameInstallments.contains(" Meses") ) {
        installment = int.parse(nameInstallments.replaceAll(" Meses", ""));
      } else {
        installment = 1;
      }

      for ( int i = 0; i < installment; i++ ) {

        month = ReleaseFunction().calculateMonth(month + i + 1);

        if (month == 1) {
          year = year + 1;
        }

        DateTime? dateFormatted;
        if (month < 10) {
          dateFormatted = DateTime.parse("$year-0$month-$day 00:00:00.000");
        } else {
          dateFormatted = DateTime.parse("$year-$month-$day 00:00:00.000");
        }

        String dateSchedule = DateFormat('yyyyMMddkkmmss').format(dateFormatted);

        var dataScheduled = {
          "user_uid": userUid,
          "document": dateSchedule,
          "value": valueFormatted,
          "description": description,
          "type": type,
          "category": category,
          "account_id": accountId,
          "date": dateFormatted.toString(),
          "status": 0,
        };

        await _db.collection("releases").doc(dateSchedule).set(dataScheduled);
      }
    }

  }

  // atualizar o valor da conta
  updateAccount( num value, String oldValue, int screenActive, String accountId, context, String? originAccountId, String? originValue ) async {
    num valueParse = num.parse(oldValue.replaceAll(".", "").replaceAll(",", "."));

    String newValue;
    if ( screenActive == 1 ) {
      newValue = decrementValue(valueParse, value);
    } else if ( screenActive == 2 ) {
      newValue = sumValue(valueParse, value);
    } else {
      newValue = sumValue(valueParse, value);

      if ( originAccountId != null ) {

        num originValueParse = num.parse(originValue!.replaceAll(".", "").replaceAll(",", "."));
        String newOriginValue = decrementValue(originValueParse, value);
        var originData = {
          "value": newOriginValue,
        };

        _db.collection("accounts").doc(originAccountId).update(originData);
      }

    }

    var data = {
      "value": newValue,
    };

    _db.collection("accounts").doc(accountId).update(data);

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