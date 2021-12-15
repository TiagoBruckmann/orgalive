// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:awesome_select/awesome_select.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:image_picker/image_picker.dart';

// import dos modelos
import 'package:orgalive/Model/Core/model_choices.dart' as model_choices;
import 'package:orgalive/Model/Core/styles/orgalive_colors.dart';

// import das telas
import 'package:orgalive/Screens/widgets/message_widget.dart';

class BodyFutureReleases extends StatefulWidget {

  final int screenActive;
  const BodyFutureReleases({ Key? key, required this.screenActive }) : super(key: key);

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

  // seleciona a imagem do computador
  Future _selectImage( String imageSource ) async {
    try {

      XFile? image;
      switch ( imageSource ) {
        case "camera":
            image = await _picker.pickImage(source: ImageSource.camera);
        break;
        case "gallery":
          image = await _picker.pickImage(source: ImageSource.gallery);
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

  _saveRelease() async {

    if ( widget.screenActive == 1 ) {
      // despesa

      if ( _imageFileList != null ) {
        _uploadImage();
      }
    } else if ( widget.screenActive == 2 ) {
      // lucro / faturamento
      if ( _imageFileList != null ) {
        _uploadImage();
      }
    } else {
      // transferencia
      if ( _imageFileList != null ) {
        _uploadImage();
      }
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
            child: FindDropdown(
              backgroundColor: OrgaliveColors.greyBackground,
              items: const [
                "Brasil",
                "Itália",
                "Estados Unidos",
                "Canadá",
              ],
              showSearchBox: false,
              // onFind: (items) => _getMedics(),
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
                print("item => $item");
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
                              ? "Selecione uma categoria"
                              : "$item",
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
                        "$item",
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
          ListTile(
            title: const Text(
              "Pagar com",
              style: TextStyle(
                color: OrgaliveColors.silver,
                fontSize: 16,
              ),
            ),

            subtitle: Row(
              children: [

                Card(
                  color: OrgaliveColors.bossanova,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(7),
                    child: Icon(
                      Icons.home,
                      color: OrgaliveColors.silver,
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only( left: 10, ),
                  child: Text(
                    "Conta inicial",
                    style: TextStyle(
                      color: OrgaliveColors.whiteSmoke,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ),

              ],
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
