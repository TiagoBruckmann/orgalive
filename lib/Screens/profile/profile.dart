// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos modelos
import 'package:orgalive/Model/Core/styles/orgalive_colors.dart';

// import dos pacotes
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {

  final String name;
  const Profile({ Key? key, required this.name }) : super(key: key);

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

  // validar os dados do perfil
  _verifyProfile() {

  }

  _updateProfile() {

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
                          "https://ui-avatars.com/api/?name=${widget.name}"
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
