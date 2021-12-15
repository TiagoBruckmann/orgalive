// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos modelos
import 'package:orgalive/Model/Core/styles/orgalive_colors.dart';

// import dos pacotes
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({ Key? key }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  // controlladores
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerMail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final MaskedTextController _controllerYearBirth = MaskedTextController( mask: "00/00/0000" );
  final TextEditingController _controllerGenre = TextEditingController();

  // variaveis da tela
  String? _userName;

  // detalhes do documento
  final _picker = ImagePicker();
  List<XFile>? _imageFileList;
  String? _errorPicture;

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  // configuracao da camera
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

  // selecionar imagem
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
      .child("users")
      .child(_imageFileList![0].name);

    final metadata = firebase_storage.SettableMetadata(
      contentType: '${_imageFileList![0].mimeType}',
      customMetadata: {'picked-file-path': _imageFileList![0].path},
    );

    uploadTask = arquive.putData(await _imageFileList![0].readAsBytes(), metadata);

    return Future.value(uploadTask);
  }

  // validar os dados do perfil
  _verifyProfile() {

  }

  _updateProfile() {

    if ( _imageFileList != null ) {
      _uploadImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            const Text("Perfil"),

            GestureDetector(
              onTap: () {
                _verifyProfile();
              },
              child: const Text("Salvar"),
            )
          ],
        ),
      ),

      body: SingleChildScrollView(
        // padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
        child: Column(
          children: [

            // imagem
            ListTile(
              leading: GestureDetector(
                onTap: () {
                  _settingCamera();
                },
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://ui-avatars.com/api/?name=${_userName!}",
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                _userName!,
                style: const TextStyle(
                  color: OrgaliveColors.whiteSmoke,
                  fontSize: 18,
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

            // nome email e senha
            Card(
              color: OrgaliveColors.greyDefault,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric( horizontal: 10, vertical: 10 ),
                child: Column(
                  children: [

                    // nome
                    Padding(
                      padding: const EdgeInsets.symmetric( vertical: 10 ),
                      child: TextField(
                        controller: _controllerName,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(
                          color: OrgaliveColors.whiteSmoke,
                          fontSize: 15,
                        ),
                        textInputAction: TextInputAction.next,
                        onSubmitted: ( value ) {
                          setState(() {
                            _userName = value;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric( horizontal: 5, vertical: 16 ),
                          labelText: "Nome",
                          labelStyle: const TextStyle(
                            color: OrgaliveColors.whiteSmoke,
                            fontSize: 15,
                          ),
                          suffixIcon: const Padding(
                            padding: EdgeInsets.only( top: 10 ),
                            child: FaIcon(
                              FontAwesomeIcons.solidUser,
                              color: OrgaliveColors.whiteSmoke,
                            ),
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

                    // email
                    Padding(
                      padding: const EdgeInsets.only( bottom: 10 ),
                      child: TextField(
                        controller: _controllerMail,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(
                          color: OrgaliveColors.whiteSmoke,
                          fontSize: 15,
                        ),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
                          labelText: "E-mail",
                          labelStyle: const TextStyle(
                            color: OrgaliveColors.whiteSmoke,
                            fontSize: 15,
                          ),
                          suffixIcon: const Padding(
                            padding: EdgeInsets.only( top: 10 ),
                            child: FaIcon(
                              FontAwesomeIcons.solidEnvelope,
                              color: OrgaliveColors.whiteSmoke,
                            ),
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

                    // senha
                    Padding(
                      padding: const EdgeInsets.only( bottom: 10 ),
                      child: TextField(
                        controller: _controllerPassword,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          color: OrgaliveColors.whiteSmoke,
                          fontSize: 15,
                        ),
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
                          labelText: "Senha",
                          labelStyle: const TextStyle(
                            color: OrgaliveColors.whiteSmoke,
                            fontSize: 15,
                          ),
                          suffixIcon: const Padding(
                            padding: EdgeInsets.only( top: 10 ),
                            child: FaIcon(
                              FontAwesomeIcons.lock,
                              color: OrgaliveColors.whiteSmoke,
                            ),
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

                  ],
                ),
              ),
            ),

            // nome email e senha
            Card(
              color: OrgaliveColors.greyDefault,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all( 10 ),
                child: Column(
                  children: [

                    // aniversario
                    Padding(
                      padding: const EdgeInsets.symmetric( vertical: 10 ),
                      child: TextField(
                        controller: _controllerYearBirth,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          color: OrgaliveColors.whiteSmoke,
                          fontSize: 15,
                        ),
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
                          labelText: "Data de nascimento",
                          labelStyle: const TextStyle(
                            color: OrgaliveColors.whiteSmoke,
                            fontSize: 15,
                          ),
                          filled: true,
                          suffixIcon: const Padding(
                            padding: EdgeInsets.only( top: 10 ),
                            child: FaIcon(
                              FontAwesomeIcons.calendarAlt,
                              color: OrgaliveColors.whiteSmoke,
                            ),
                          ),
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

                    // genero
                    Padding(
                      padding: const EdgeInsets.only( bottom: 10 ),
                      child: TextField(
                        controller: _controllerGenre,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(
                          color: OrgaliveColors.whiteSmoke,
                          fontSize: 15,
                        ),
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
                          labelText: "Gênero",
                          labelStyle: const TextStyle(
                            color: OrgaliveColors.whiteSmoke,
                            fontSize: 15,
                          ),
                          suffixIcon: const Padding(
                            padding: EdgeInsets.only( top: 10 ),
                            child: FaIcon(
                              FontAwesomeIcons.venusMars,
                              color: OrgaliveColors.whiteSmoke,
                            ),
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

                  ],
                ),
              )
            ),

          ],
        ),
      ),
    );
  }
}
