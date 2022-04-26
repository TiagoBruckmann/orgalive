// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos modelos
import 'package:orgalive/core/firebase/model_firebase.dart';
import 'package:orgalive/core/styles/orgalive_colors.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

// import dos pacotes
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import das telas
import 'package:orgalive/screens/widgets/loading_connection.dart';
import 'package:orgalive/screens/widgets/message_widget.dart';

// gerenciadores de estado
import 'package:orgalive/mobx/connection/connection_mobx.dart';

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
  bool _passwdVisible = false;
  String? _password;

  // variaveis do banco
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // gerenciadores de estado
  late ConnectionMobx _connectionMobx;

  // alterar a visibilidade da senha
  _changeVisible() {
    if ( _passwdVisible == false ) {
      setState(() {
        _passwdVisible = true;
      });
    } else {
      setState(() {
        _passwdVisible = false;
      });
    }
  }

  _getProfile() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? userData = auth.currentUser;

    _uid = userData!.uid;

    var data = await _db.collection("users").where("uid", isEqualTo: _uid).get();

    for ( var item in data.docs ) {

      setState(() {
        _controllerName.text = item["name"];
        _controllerMail.text = item["mail"];
        _controllerYearBirth.text = item["year_birth"];
        _password = item["password"];
      });
    }

  }

  // validar os dados do perfil
  _verifyProfile() {

    if ( _controllerName.text.isEmpty || _controllerName.text.length < 3 ) {

      CustomSnackBar( context, "Preencha um nome válido", OrgaliveColors.redDefault );

    } else if ( _controllerMail.text.isEmpty && !_controllerMail.text.contains("@") || !_controllerMail.text.contains(".com") && !_controllerMail.text.contains(".br") ) {

      CustomSnackBar( context, "Preencha um e-mail válido", OrgaliveColors.redDefault );

    } else if ( _controllerYearBirth.text.isEmpty || _controllerYearBirth.text.length != 10 ) {

      CustomSnackBar( context, "Preencha uma data de nascimento válida", OrgaliveColors.redDefault );

    } else {

      _updateProfile();

    }
  }

  // atualizar perfil
  _updateProfile() {

    FirebaseFirestore db = FirebaseFirestore.instance;

    String? password;
    if ( _controllerPassword.text.trim().isNotEmpty ) {
      password = _controllerPassword.text;
    } else {
      password = _password;
    }
    var data = {
      "name": _controllerName.text,
      "mail": _controllerMail.text,
      "year_birth": _controllerYearBirth.text,
      "password": password,
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
  void didChangeDependencies() async {
    super.didChangeDependencies();

    _connectionMobx = Provider.of<ConnectionMobx>(context);

    await _connectionMobx.verifyConnection();
    _connectionMobx.connectivity.onConnectivityChanged.listen(_connectionMobx.updateConnectionStatus);

  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (builder) {

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
                ),
              ],
            ),
          ),

          body: ( _connectionMobx.connectionStatus.toString() == "ConnectivityResult.none" )
          ? const LoadingConnection()
          : SingleChildScrollView(
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
                            keyboardType: TextInputType.text,
                            obscureText: ( _passwdVisible == false )
                            ? true
                            : false,
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
                              suffixIcon: TextButton(
                                onPressed: () {
                                  _changeVisible();
                                },
                                child: Icon(
                                  ( _passwdVisible == false )
                                  ? Icons.visibility_off
                                  : Icons.visibility,
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
                                  FontAwesomeIcons.calendarDays,
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

                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        );

      },
    );
  }
}
