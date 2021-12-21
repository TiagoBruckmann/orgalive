// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos modelos
import 'package:orgalive/Model/Core/firebase/model_firebase.dart';
import 'package:orgalive/Model/Core/styles/orgalive_colors.dart';

// import dos pacotes
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:find_dropdown/find_dropdown.dart';

// import das telas
import 'package:orgalive/Screens/widgets/message_widget.dart';

class Profile extends StatefulWidget {

  final String photo;
  final String name;
  const Profile({ Key? key, required this.photo, required this.name }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  // controlladores
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerMail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final MaskedTextController _controllerYearBirth = MaskedTextController( mask: "00/00/0000" );

  // variaveis da tela
  String? _uid;
  String? _userName;
  String _genre = "";

  _getProfile() {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? userData = auth.currentUser;

    _uid = userData!.uid;
    _controllerName.text = userData.displayName!;
    _controllerMail.text = userData.email!;

  }

  // validar os dados do perfil
  _verifyProfile() {

    if ( _controllerName.text.isEmpty || _controllerName.text.length < 3 ) {

      CustomSnackBar( context, "Preencha um nome válido", OrgaliveColors.redDefault );

    } else if ( _controllerMail.text.isEmpty && !_controllerMail.text.contains("@") || !_controllerMail.text.contains(".com") && !_controllerMail.text.contains(".br") ) {

      CustomSnackBar( context, "Preencha um e-mail válido", OrgaliveColors.redDefault );

    } else if ( _controllerYearBirth.text.isEmpty || _controllerYearBirth.text.length != 10 ) {

      CustomSnackBar( context, "Preencha uma data de nascimento válida", OrgaliveColors.redDefault );

    } else if ( _genre.isEmpty ) {

      CustomSnackBar( context, "Selecione um gênero", OrgaliveColors.redDefault );

    } else {

      _updateProfile();

    }
  }

  // atualizar perfil
  _updateProfile() {

    FirebaseFirestore db = FirebaseFirestore.instance;

    var data = {
      "name": _controllerName.text,
      "mail": _controllerMail.text,
      "year_birth": _controllerYearBirth.text,
      "genre": _genre,
    };

    db.collection("users").doc(_uid).update(data);

    CustomSnackBar( context, "Dados atualizados com sucesso", OrgaliveColors.greenDefault );

  }

  @override
  void initState() {
    super.initState();
    Analytics().sendScreen("profile");
    _getProfile();
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
            Padding(
              padding: const EdgeInsets.symmetric( vertical: 15 ),
              child: ListTile(
                leading: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                        ( widget.photo.isEmpty )
                        ? "https://ui-avatars.com/api/?name=${widget.name}"
                        : widget.photo,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  ( _userName == null )
                  ? widget.name
                  : _userName!,
                  style: const TextStyle(
                    color: OrgaliveColors.whiteSmoke,
                    fontSize: 18,
                  ),
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
                    FindDropdown(
                      backgroundColor: OrgaliveColors.greyBackground,
                      items: const [
                        "Masculino",
                        "Femenino",
                      ],
                      showSearchBox: false,
                      label: "Selecione um gênero",
                      labelStyle: const TextStyle(
                        color: OrgaliveColors.whiteSmoke,
                      ),
                      titleStyle: const TextStyle(
                        color: OrgaliveColors.whiteSmoke,
                      ),
                      errorBuilder: ( context, item ) {
                        return const Center(
                          child: Text(
                            "Nenhum gênero encontrado",
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
                            "Nenhum gênero encontrado",
                            style: TextStyle(
                              color: OrgaliveColors.whiteSmoke,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                      onChanged: ( item ) {
                        setState(() {
                          _genre = item.toString();
                        });
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
                                  ? "Selecione um gênero"
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

                      // constroi a exibição os generos
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
