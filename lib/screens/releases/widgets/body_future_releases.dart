// imports nativos do flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:awesome_select/awesome_select.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// import dos modelos
import 'package:orgalive/model/core/model_choices.dart' as model_choices;
import 'package:orgalive/model/core/styles/orgalive_colors.dart';
import 'package:orgalive/model/functions/accounts/account.dart';
import 'package:orgalive/model/model_accounts.dart';
import 'package:orgalive/model/model_categories.dart';
import 'package:orgalive/screens/home.dart';

// import das telas
import 'package:orgalive/screens/widgets/message_widget.dart';

class BodyFutureReleases extends StatefulWidget {

  final int screenActive;
  final String userUid;
  const BodyFutureReleases({ Key? key, required this.screenActive, required this.userUid }) : super(key: key);

  @override
  _BodyFutureReleasesState createState() => _BodyFutureReleasesState();
}

class _BodyFutureReleasesState extends State<BodyFutureReleases> {

  // configurar o valor da conta
  final MoneyMaskedTextController _controllerExpense = MoneyMaskedTextController( leftSymbol: 'R\$ ', thousandSeparator: '.', decimalSeparator: ',' );
  final MoneyMaskedTextController _controllerProfit = MoneyMaskedTextController( leftSymbol: 'R\$ ', thousandSeparator: '.', decimalSeparator: ',' );
  final MoneyMaskedTextController _controllerTransfer = MoneyMaskedTextController( leftSymbol: 'R\$ ', thousandSeparator: '.', decimalSeparator: ',' );
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerTags = TextEditingController();
  final TextEditingController _controllerObs = TextEditingController();

  // variaveis da tela
  final DateTime _currentYear = DateTime.now();
  DateTime? _daySelected;
  String _timeExpense = "month";
  String _nameTimeExpense = "fixa";
  String _installments = "2";
  String _nameInstallments = "parcelada";
  String? _category;
  String? _accountId;
  String? _oldValue;

  // variaveis do banco
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // buscar as contas cadastradas do usuario
  Future<List<ModelAccounts>> _getAccounts() async {

    List<ModelAccounts> listAccounts = [];

    var data = await _db.collection("accounts").where("user_uid", isEqualTo: widget.userUid).get();

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

    setState(() {
      listAccounts.addAll(list);
    });

    return listAccounts;

  }

  // buscar todas as categorias de servicos
  Future<List<ModelCategories>> _getCategories() async {

    List<ModelCategories> listCategories = [];

    var data = await _db.collection("categories").get();

    List<ModelCategories> list = [];

    print("data.docs => ${data.docs}");
    for ( var item in data.docs ) {

      print("item => ${item["icon"]}");
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

    setState(() {
      listCategories.addAll(list);
    });

    return listCategories;

  }

  // detalhes do documento
  final _picker = ImagePicker();
  List<XFile>? _imageFileList;
  String? _errorPicture;

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  // seleção do serviço da camera
  _settingCamera() {
    final snackBar = SnackBar(
      content: ListTile(
        title: TextButton(
          child: const Text("Camera"),
          onPressed: () {
            _selectImage("camera");
          },
        ),
        subtitle: TextButton(
          child: const Text("Galeria"),
          onPressed: () {
            _selectImage("gallery");
          },
        ),
      ),
    );

    return snackBar;
  }

  // seleciona a imagem do comprovante
  Future _selectImage( String imageSource ) async {
    try {

      XFile? image;
      switch ( imageSource ) {
        case "camera": image = await _picker.pickImage(source: ImageSource.camera);
        break;
        case "gallery": image = await _picker.pickImage(source: ImageSource.gallery);
        break;
      }

      if (image != null) {
        setState(() {
          _imageFile = image;
        });
      }
    } catch (e) {
      _errorPicture = e.toString();
    }
  }

  // faz o envio da imagem para o storage
  Future _uploadImage() async {
    firebase_storage.UploadTask uploadTask;

    firebase_storage.Reference arquive = firebase_storage
      .FirebaseStorage.instance
      .ref()
      .child("documents")
      .child(_imageFileList![0].name);

    final metadata = firebase_storage.SettableMetadata(
      contentType: '${_imageFileList![0].mimeType}',
      customMetadata: {'picked-file-path': _imageFileList![0].path},
    );

    uploadTask = arquive.putData(await _imageFileList![0].readAsBytes(), metadata);

    return Future.value(uploadTask);
  }

  // validar lancamento
  _validateFields() {

    // valores
    if ( _controllerExpense.text == "R\$ 0,00" && widget.screenActive == 1 ) {
      CustomSnackBar(context, "Insira um valor válido", OrgaliveColors.redDefault);
    }

    if ( _controllerProfit.text == "R\$ 0,00" && widget.screenActive == 2 ) {
      CustomSnackBar(context, "Insira um valor válido", OrgaliveColors.redDefault);
    }

    if ( _controllerTransfer.text == "R\$ 0,00" && widget.screenActive == 3 ) {
      CustomSnackBar(context, "Insira um valor válido", OrgaliveColors.redDefault);
    }

    // descricao
    if ( _controllerDescription.text.trim().isEmpty ) {
      CustomSnackBar(context, "Insira uma descrição para o lançamento", OrgaliveColors.redDefault);
    }

    // dia selecionado para
    if ( _daySelected == null ) {
      CustomSnackBar(context, "selecione uma data para o valor ser lançado", OrgaliveColors.redDefault);
    }

    if (
      _controllerExpense.text != "R\$ 0,00" || _controllerProfit.text != "R\$ 0,00" || _controllerTransfer.text != "R\$ 0,00" &&
      _controllerDescription.text.trim().isNotEmpty && _daySelected != null
    ) {
      _saveRelease();
    }
  }

  // salvar lancamento
  _saveRelease() async {

    // salvar arquivo
    if ( _imageFileList != null ) {
      _uploadImage();
    }

    num value;
    String valueFormated;
    String type;
    if ( widget.screenActive == 1 ) {

      valueFormated = _controllerExpense.text.replaceAll("R\$ ", "");
      num rmString = num.parse(_controllerExpense.text.replaceAll("R\$ ", "").replaceAll(".", "").replaceAll(",", "."));
      value = rmString;
      type = "Despesa";

    } else if ( widget.screenActive == 2 ) {

      valueFormated = _controllerProfit.text.replaceAll("R\$ ", "");
      num rmString = num.parse(_controllerProfit.text.replaceAll("R\$ ", "").replaceAll(".", "").replaceAll(",", "."));
      value = rmString;
      type = "Lucro";

    } else {

      valueFormated = _controllerTransfer.text.replaceAll("R\$ ", "");
      num rmString = num.parse(_controllerTransfer.text.replaceAll("R\$ ", "").replaceAll(".", "").replaceAll(",", "."));
      value = rmString;
      type = "Transferência";

    }

    DateTime now = DateTime.now();
    String dateNow = DateFormat('yyyyMMddkkmmss').format(now);

    int? status;
    if ( _daySelected!.month >= now.month && _daySelected!.day >= now.day ) {

      if ( _daySelected!.month > now.month ) {
        status = 0;
      } else if ( _daySelected!.month == now.month && _daySelected!.day > now.day ) {
        status = 0;
      } else if ( _daySelected!.month == now.month && _daySelected!.day == now.day ) {
        status = 1;
      }
    } else {
      status = 1;
    }

    var data = {
      "user_uid": widget.userUid,
      "document": dateNow,
      "value": valueFormated,
      "description": _controllerDescription.text,
      "type": type,
      "category": _category,
      "account_id": _accountId,
      "date": _daySelected.toString(),
      "Status": status,
    };

    await _db.collection("releases").doc(dateNow).set(data);

    _updateAccount( value );
  }

  // atualizar o valor da conta
  _updateAccount( num value ) async {

    num oldValue = num.parse(_oldValue!.replaceAll(".", "").replaceAll(",", "."));

    String newValue;
    if ( widget.screenActive == 2 ) {
      newValue = AccountFunction().sumValue(oldValue, value);
    } else {
      newValue = AccountFunction().decrementValue(oldValue, value);
    }

    var data = {
      "value": newValue,
    };

    _db.collection("accounts").doc(_accountId!.toString()).update(data);

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
      ( widget.screenActive == 1 )
      ? "Despesa cadastrada com sucesso"
      : ( widget.screenActive == 2 )
      ? "Lucro cadastrado com sucesso"
      : "Transferência cadastrada com sucesso",
      OrgaliveColors.greenDefault,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [

          // valores
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: TextField(
              controller: ( widget.screenActive == 1 )
              ? _controllerExpense
              : ( widget.screenActive == 2 )
              ? _controllerProfit
              : _controllerTransfer,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              style: const TextStyle(
                color: OrgaliveColors.whiteSmoke,
                fontSize: 20,
              ),
              autofocus: false,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
                filled: true,
                suffixIcon: Padding(
                  padding: const EdgeInsets.only( top: 10 ),
                  child: FaIcon(
                    ( widget.screenActive == 1 )
                    ? FontAwesomeIcons.solidThumbsDown
                    : ( widget.screenActive == 2 )
                    ? FontAwesomeIcons.solidThumbsUp
                    : FontAwesomeIcons.solidThumbsDown,
                    color: OrgaliveColors.whiteSmoke,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: OrgaliveColors.silver,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: OrgaliveColors.silver,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),

          // descricao do valor
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: TextField(
              controller: _controllerDescription,
              keyboardType: TextInputType.text,
              style: const TextStyle(
                color: OrgaliveColors.whiteSmoke,
                fontSize: 20,
              ),
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
                labelText: "Descrição",
                labelStyle: const TextStyle(
                  color: OrgaliveColors.silver,
                ),
                filled: true,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: OrgaliveColors.silver,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: OrgaliveColors.silver,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),

          // listagem das categorias
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: FindDropdown<ModelCategories>(
              backgroundColor: OrgaliveColors.greyBackground,
              showSearchBox: false,
              onFind: (items) => _getCategories(),
              label: "Selecione uma categoria",
              labelStyle: const TextStyle(
                color: OrgaliveColors.whiteSmoke,
              ),
              titleStyle: const TextStyle(
                color: OrgaliveColors.whiteSmoke,
              ),
              errorBuilder: ( context, item ) {
                return const Center(
                  child: Text(
                    "Nenhuma categoria encontrada",
                    style: TextStyle(
                      color: OrgaliveColors.whiteSmoke,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
              emptyBuilder: ( item ) {
                return const Center(
                  child: Text(
                    "Nenhuma categoria encontrada",
                    style: TextStyle(
                      color: OrgaliveColors.whiteSmoke,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
              onChanged: ( item ) {
                _category = item!.name;
              },
              dropdownBuilder: (BuildContext context, item) {
                // print("item.icon 1 => ${item!.icon}");
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: OrgaliveColors.silver,
                    ),
                    borderRadius: BorderRadius.circular(5),
                    color: OrgaliveColors.greyBackground,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: OrgaliveColors.bossanova,
                      child: Icon(
                        Icons.home,
                        color: OrgaliveColors.silver,
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          /*( item!.name == null )
                          ? */"Selecione uma categoria"/*
                          : "${item.name}"*/,
                          style: TextStyle(
                            color: OrgaliveColors.whiteSmoke,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },

              // constroi a exibição das categorias
              dropdownItemBuilder: ( BuildContext context, item, bool isSelected ) {
                print("item.icon 2 => ${item.icon}");
                return Container(
                  decoration: !isSelected
                  ? null
                  : BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: OrgaliveColors.bossanova,
                  ),
                  child: Card(
                    color: OrgaliveColors.greyDefault,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ListTile(
                      selected: isSelected,
                      leading: CircleAvatar(
                        backgroundColor: OrgaliveColors.bossanova,
                        child: Icon(
                          Icons.home,
                          color: OrgaliveColors.silver,
                        ),
                      ),
                      title: Text(
                        "${item.name}",
                        style: const TextStyle(
                          color: OrgaliveColors.whiteSmoke,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // pagar com
          Padding(
            padding: const EdgeInsets.symmetric( horizontal: 16, vertical: 12 ),
            child: FindDropdown<ModelAccounts>(
              backgroundColor: OrgaliveColors.greyBackground,
              showSearchBox: false,
              onFind: (items) => _getAccounts(),
              label: "Pagar com",
              labelStyle: const TextStyle(
                color: OrgaliveColors.whiteSmoke,
              ),
              titleStyle: const TextStyle(
                color: OrgaliveColors.whiteSmoke,
              ),
              errorBuilder: ( context, item ) {
                return const Center(
                  child: Text(
                    "Nenhuma conta encontrada",
                    style: TextStyle(
                      color: OrgaliveColors.whiteSmoke,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
              emptyBuilder: ( item ) {
                return const Center(
                  child: Text(
                    "Nenhuma conta encontrada",
                    style: TextStyle(
                      color: OrgaliveColors.whiteSmoke,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
              onChanged: ( item ) {
                _accountId = item!.document;
                _oldValue = item.value;
                // _category = item.name;
              },
              dropdownBuilder: (BuildContext context, item) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: OrgaliveColors.silver,
                    ),
                    borderRadius: BorderRadius.circular(5),
                    color: OrgaliveColors.greyBackground,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: OrgaliveColors.bossanova,
                      child: Icon(
                        Icons.home,
                        color: OrgaliveColors.silver,
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (item == null)
                              ? "Selecione uma conta"
                              : "${item.name}",
                          style: const TextStyle(
                            color: OrgaliveColors.whiteSmoke,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },

              // constroi a exibição das categorias
              dropdownItemBuilder: ( BuildContext context, item, bool isSelected ) {
                return Container(
                  decoration: !isSelected
                      ? null
                      : BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: OrgaliveColors.bossanova,
                  ),
                  child: Card(
                    color: OrgaliveColors.greyDefault,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ListTile(
                      selected: isSelected,
                      leading: const CircleAvatar(
                        backgroundColor: OrgaliveColors.bossanova,
                        child: Icon(
                          Icons.home,
                          color: OrgaliveColors.silver,
                        ),
                      ),
                      title: Text(
                        "${item.name}",
                        style: const TextStyle(
                          color: OrgaliveColors.whiteSmoke,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // data de lancamento
          ListTile(
            title: const Text(
              "Data",
              style: TextStyle(
                color: OrgaliveColors.silver,
                fontSize: 16,
              ),
            ),

            subtitle: CalendarTimeline(
              initialDate: _currentYear,
              firstDate: DateTime(2021, 12, 06),
              lastDate: DateTime(2023, 12, 06),
              leftMargin: 16,
              onDateSelected: (date) {
                _daySelected = date;
              },
              monthColor: OrgaliveColors.silver,
              dayColor: OrgaliveColors.bossanova,
              activeDayColor: OrgaliveColors.silver,
              activeBackgroundDayColor: OrgaliveColors.bossanova,
              dotsColor: OrgaliveColors.bossanova,
              locale: 'pt_BR',
            ),
          ),

          // repetir lancamento
          Padding(
            padding: const EdgeInsets.only( left: 16, top: 10 ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [

                Text(
                  "Repetir lançamento",
                  style: TextStyle(
                    color: OrgaliveColors.silver,
                    fontSize: 18,
                  ),
                ),

              ],
            ),
          ),

          // despesa fixa
          SmartSelect<String?>.single(
            title: ( widget.screenActive == 1 )
            ? "Despesa fixa"
            : ( widget.screenActive == 2 )
            ? "Receita fixa"
            : "Transferência fixa",
            selectedValue: _timeExpense,
            choiceItems: model_choices.fixed,
            onChange: (selected) {
              setState(() {
                _timeExpense = selected.value!;
                _nameTimeExpense = selected.title!;
              });
            },
            modalType: S2ModalType.bottomSheet,
            tileBuilder: (context, state) {
              return S2Tile.fromState(
                state,
                isTwoLine: false,
                title: Padding(
                  padding: const EdgeInsets.only( left: 20 ),
                  child: Text(
                    ( _nameTimeExpense == "fixa" && widget.screenActive == 1 )
                    ? "Despesa fixa"
                    : ( _nameTimeExpense == "fixa" && widget.screenActive == 2 )
                    ? "Receita fixa"
                    : ( _nameTimeExpense == "fixa" && widget.screenActive == 3 )
                    ? "Transferência fixa"
                    : ( _nameTimeExpense != "fixa" && widget.screenActive == 1 )
                    ? "Despesa fixa $_nameTimeExpense"
                    : ( _nameTimeExpense != "fixa" && widget.screenActive == 2 )
                    ? "Receita fixa $_nameTimeExpense"
                    : "Transferência fixa $_nameTimeExpense",
                    style: const TextStyle(
                      color: OrgaliveColors.whiteSmoke,
                    ),
                  ),
                )
              );
            },
          ),

          // depesa parcelada
          SmartSelect<String?>.single(
            title: ( widget.screenActive == 1 )
            ? "Despesa parcelada"
            : ( widget.screenActive == 2 )
            ? "Receita parcelada"
            : "Transferência parcelada",
            selectedValue: _installments,
            choiceItems: model_choices.installments,
            onChange: (selected) {
              setState(() {
                _installments = selected.value!;
                _nameInstallments = selected.title!;
              });
            },
            modalType: S2ModalType.bottomSheet,
            tileBuilder: (context, state) {
              return S2Tile.fromState(
                state,
                isTwoLine: false,
                title: Padding(
                  padding: const EdgeInsets.only( left: 20 ),
                  child: Text(
                    ( _nameInstallments == "parcelada" && widget.screenActive == 1 )
                    ? "Despesa parcelada"
                    : ( _nameInstallments == "parcelada" && widget.screenActive == 2 )
                    ? "Receita parcelada"
                    : ( _nameInstallments == "parcelada" && widget.screenActive == 3 )
                    ? "Transferência parcelada"
                    : "Parcelado em $_nameInstallments",
                    style: const TextStyle(
                      color: OrgaliveColors.whiteSmoke,
                    ),
                  ),
                )
              );
            },
          ),

          // detalhes do lancamento
          ExpansionTile(
            title: const Text(
              "Detalhes do lançamento",
              style: TextStyle(
                color: OrgaliveColors.silver,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            children: [

              // tags
              ListTile(
                title: const Padding(
                  padding: EdgeInsets.only( bottom: 10 ),
                  child: Text(
                    "Tags",
                    style: TextStyle(
                      color: OrgaliveColors.bossanova,
                      fontSize: 16,
                    ),
                  ),
                ),
                subtitle: TextField(
                  controller: _controllerTags,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(
                    color: OrgaliveColors.whiteSmoke,
                    fontSize: 15,
                  ),
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
                    hintText: "Anexar tags",
                    hintStyle: const TextStyle(
                      color: OrgaliveColors.whiteSmoke,
                      fontSize: 15,
                    ),
                    prefixIcon: const FaIcon(
                      FontAwesomeIcons.tag,
                      color: OrgaliveColors.whiteSmoke,
                    ),
                    filled: true,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: OrgaliveColors.greyBackground,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: OrgaliveColors.greyBackground,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),

              // observacao
              ListTile(
                title: const Padding(
                  padding: EdgeInsets.only( bottom: 10 ),
                  child: Text(
                    "Observação",
                    style: TextStyle(
                      color: OrgaliveColors.bossanova,
                      fontSize: 16,
                    ),
                  ),
                ),
                subtitle: TextField(
                  controller: _controllerObs,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(
                    color: OrgaliveColors.whiteSmoke,
                    fontSize: 15,
                  ),
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
                    hintText: "Adicione alguma observação",
                    hintStyle: const TextStyle(
                      color: OrgaliveColors.whiteSmoke,
                      fontSize: 15,
                    ),
                    prefixIcon: const FaIcon(
                      FontAwesomeIcons.tag,
                      color: OrgaliveColors.whiteSmoke,
                    ),
                    filled: true,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: OrgaliveColors.greyBackground,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: OrgaliveColors.greyBackground,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),

              // anexos
              ListTile(
                title: const Padding(
                  padding: EdgeInsets.only( bottom: 10 ),
                  child: Text(
                    "Anexos",
                    style: TextStyle(
                      color: OrgaliveColors.bossanova,
                      fontSize: 16,
                    ),
                  ),
                ),
                subtitle: GestureDetector(
                  onTap: () {
                    _settingCamera();
                  },
                  child: Row(
                    children: [

                      const FaIcon(
                        FontAwesomeIcons.fileUpload,
                        color: OrgaliveColors.whiteSmoke,
                      ),

                      Padding(
                        padding: const EdgeInsets.only( left: 10 ),
                        child: Text(
                          ( _imageFileList == null )
                          ? "Adicionar anexo"
                          : _imageFileList![0].name,
                          style: const TextStyle(
                            color: OrgaliveColors.whiteSmoke,
                            fontSize: 15,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              // erro na foto
              ( _errorPicture == null )
              ? const Padding(padding: EdgeInsets.zero)
              : Text(
                "$_errorPicture",
                style: const TextStyle(
                  color: OrgaliveColors.redDefault,
                  fontSize: 15,
                ),
              ),

            ],
          ),

          // salvar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(
                    ( widget.screenActive == 1 )
                    ? "Cadastrar despesa"
                    : ( widget.screenActive == 2 )
                    ? "Cadastrar lucro"
                    : "Cadastrar transferência",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),

                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: OrgaliveColors.greenDefault,
                padding: const EdgeInsets.fromLTRB(36, 16, 36, 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                _validateFields();
              }
            ),
          ),

        ],
      ),
    );
  }
}
