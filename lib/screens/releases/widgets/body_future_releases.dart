// imports nativos do flutter
import 'dart:async';

import 'package:flutter/material.dart';

// import dos pacotes
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:image_picker/image_picker.dart';

// import dos modelos
import 'package:orgalive/model/core/styles/orgalive_colors.dart';
import 'package:orgalive/model/functions/accounts/account.dart';
import 'package:orgalive/model/model_categories.dart';
import 'package:orgalive/model/model_accounts.dart';

// import das telas
import 'package:orgalive/screens/releases/widgets/modals/modal_installments.dart';
import 'package:orgalive/screens/releases/widgets/modals/modal_fixed.dart';
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
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerTags = TextEditingController();
  final TextEditingController _controllerObs = TextEditingController();

  // variaveis da tela
  final DateTime _currentYear = DateTime.now();
  DateTime _daySelected = DateTime.now();
  String _oldValue = "";
  String _accountId = "";
  String _category = "";
  String _nameFixed = "";
  String _nameInstallments = "";

  // abrir fixados
  _goToFixed() {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModalFixed(
          screenActive: widget.screenActive,
        ),
      ),
    ).then( _onGoBackFixed );
  }

  // abrir parcelamento
  _goToInstallments() {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModalInstallments(
          screenActive: widget.screenActive,
        ),
      ),
    ).then( _onGoBackInstallments );
  }

  // setar fixado
  FutureOr _onGoBackFixed( dynamic value ) {
    setState(() {
      _nameFixed = value;
    });
  }

  // setar parcela
  FutureOr _onGoBackInstallments( dynamic value ) {
    setState(() {
      _nameInstallments = value;
    });
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

  // validar lancamento
  _validateFields() {

    // valores
    if ( _controllerExpense.text == "R\$ 0,00" && _controllerProfit.text == "R\$ 0,00" ) {
      CustomSnackBar(context, "Insira um valor válido", OrgaliveColors.redDefault);
    }

    // descricao
    if ( _controllerDescription.text.trim().isEmpty ) {
      CustomSnackBar(context, "Insira uma descrição para o lançamento", OrgaliveColors.redDefault);
    }

    if (
    _controllerExpense.text != "R\$ 0,00" || _controllerProfit.text != "R\$ 0,00" &&
        _controllerDescription.text.trim().isNotEmpty
    ) {
      String value;
      String type;
      if ( _controllerExpense.text != "R\$ 0,00" ) {
        value = _controllerExpense.text;
        type = "Despesa";
      } else {
        value = _controllerProfit.text;
        type = "Lucro";
      }

      AccountFunction().saveRelease(
        widget.userUid,
        _category,
        _oldValue,
        widget.screenActive,
        _accountId,
        _imageFileList,
        value,
        type,
        _controllerDescription.text,
        _daySelected,
        context,
        _nameFixed,
        _nameInstallments,
        null,
        null,
      );
    }
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
              : _controllerProfit,
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
                    : FontAwesomeIcons.solidThumbsUp,
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
              onFind: (items) => AccountFunction().getCategories(),
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
                _category = item!.name!;
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
                          ( _category.isEmpty )
                          ? "Selecione uma categoria"
                          : "${item!.name}",
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
                        "${item.icon}",
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
              onFind: (items) => AccountFunction().getAccounts(
                widget.userUid,
                null
              ),
              label: ( widget.screenActive == 1 )
              ? "Pagar com"
              : "receber com",
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
                _accountId = item!.document!;
                _oldValue = item.value!;
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
                _daySelected = date!;
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
          ListTile(
            title: Text(
              ( widget.screenActive == 1 && _nameFixed.isEmpty )
              ? "Despesa fixa"
              : ( widget.screenActive == 2 && _nameFixed.isEmpty )
              ? "Receita fixa"
              : ( widget.screenActive == 1 && _nameFixed.isNotEmpty )
              ? "Despesa fixa $_nameFixed"
              : "Receita fixa $_nameFixed",
              style: const TextStyle(
                color: OrgaliveColors.whiteSmoke,
              ),
            ),
            onTap: () => _goToFixed(),
          ),

          // depesa parcelada
          ListTile(
            title: Text(
              ( widget.screenActive == 1 && _nameInstallments.isEmpty )
              ? "Despesa parcelada"
              : ( widget.screenActive == 2 && _nameInstallments.isEmpty )
              ? "Receita parcelada"
              : ( widget.screenActive == 1 && _nameInstallments.isNotEmpty )
              ? "Despesa parcelada em $_nameInstallments"
              : "Receita parcelada em $_nameInstallments",
              style: const TextStyle(
                color: OrgaliveColors.whiteSmoke,
              ),
            ),
            onTap: () => _goToInstallments(),
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
                        FontAwesomeIcons.fileArrowUp,
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
                    : "Cadastrar lucro",
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
