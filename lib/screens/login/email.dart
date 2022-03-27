// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

// import dos modelos
import 'package:orgalive/model/core/firebase/model_firebase.dart';
import 'package:orgalive/model/core/styles/orgalive_colors.dart';
import 'package:orgalive/model/core/styles/app_images.dart';
import 'package:orgalive/model/model_users.dart';

// import das telas
import 'package:orgalive/screens/widgets/loading_connection.dart';
import 'package:orgalive/screens/home.dart';

// gerenciadores de estado
import 'package:orgalive/mobx/connection/connection_mobx.dart';

class Email extends StatefulWidget {

  final int type;
  const Email({ Key? key, required this.type}) : super(key: key);

  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {

  // controladores de texto
  final TextEditingController _controllerMail = TextEditingController( text: "tiago_bruck@outlook.com.br" );
  final TextEditingController _controllerPassword = TextEditingController( text: "teste1" );

  // variaveis da tela
  String _mensageError = "";
  bool _passwdVisible = false;

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

  // Validação pelo APP e envio para a API
  _validateFields(){

    //Recupera dados dos campos
    String mail = _controllerMail.text;
    String password = _controllerPassword.text;

    if( mail.isNotEmpty && mail.contains("@") || ( mail.contains(".com") || mail.contains(".br") ) ) {

      if( password.isNotEmpty && password.length > 5 ) {

        Users users = Users();
        users.mail = mail;
        users.password = password;

        if ( widget.type == 1 ) {
          _clientRegister();
        } else {
          _clientLogin( users );
        }

      } else {
        setState(() {
          _mensageError = "Preencha a senha!";
        });
      }

    } else {
      setState(() {
        _mensageError = "Preencha um e-mail válido";
      });
    }

  }

  // Validação com a API e Login
  _clientRegister() async {

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.createUserWithEmailAndPassword(
      email: _controllerMail.text,
      password: _controllerPassword.text,
    ).then((firebaseUser) async {

      //Salvar dados do usuário
      FirebaseFirestore db = FirebaseFirestore.instance;

      Users users = Users(
        name: _controllerMail.text,
        mail: _controllerMail.text,
        password: _controllerPassword.text,
        uid: firebaseUser.user!.uid,
        yearBirth: "",
        photo: "",
      );

      await db.collection("users").doc(firebaseUser.user!.uid).set(users.toMap());

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (builder) => const Home(
            selected: 0,
          ),
        ),
            (route) => false,
      );

    }).catchError((error) {

      FirebaseCrashlytics.instance.log(error.toString());
      setState(() {
        _mensageError = "Erro ao cadastrar usuário, verifique os campos e tente novamente!";
      });

    });
  }

  // acessar a conta do usuario
  _clientLogin( Users users ) {

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signInWithEmailAndPassword(
      email: users.mail!,
      password: users.password!,
    ).then((firebaseUser){

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (builder) => const Home(
            selected: 0,
          ),
        ),
            (route) => false,
      );

    }).catchError((error){

      setState(() {
        _mensageError = "Erro ao autenticar usuário, verifique seu e-mail e senha e tente novamente!";
      });

    });

  }

  @override
  void initState() {
    super.initState();
    Analytics().sendScreen("login/register");
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

          appBar: AppBar(),

          body: ( _connectionMobx.connectionStatus.toString() == "ConnectivityResult.none" )
          ? const LoadingConnection()
          : Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric( horizontal: 16 ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // logo
                  Image.asset(
                    AppImages.logo,
                    width: 250,
                  ),

                  // email
                  Padding(
                    padding: const EdgeInsets.only( top: 50, bottom: 8),
                    child: TextField(
                      controller: _controllerMail,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(
                        color: OrgaliveColors.whiteSmoke,
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(16),
                        labelText: "E-mail",
                        labelStyle: const TextStyle(
                          color: OrgaliveColors.whiteSmoke,
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: OrgaliveColors.darkGray,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: OrgaliveColors.darkGray,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        border:  OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),

                  // senha
                  TextField(
                    controller: _controllerPassword,
                    obscureText: ( _passwdVisible == false )
                    ? true
                    : false,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                      color: OrgaliveColors.whiteSmoke,
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      labelText: "Senha",
                      labelStyle: const TextStyle(
                        color: OrgaliveColors.whiteSmoke,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
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
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: OrgaliveColors.darkGray,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: OrgaliveColors.darkGray,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      border:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),

                  // mensagem de erro
                  ( _mensageError.isEmpty )
                  ? const Padding(padding: EdgeInsets.zero,)
                  : Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Center(
                      child: Text(
                        _mensageError,
                        style: const TextStyle(
                          color: OrgaliveColors.redDefault,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),

                  // acessar
                  Container(
                    padding: const EdgeInsets.only( top: 10, bottom: 10 ),
                    width: MediaQuery.of(context).size.width - 130,
                    child: ElevatedButton(
                      onPressed: () {
                        _validateFields();
                      },
                      child: Text(
                        ( widget.type == 1 )
                        ? "Cadastrar"
                        : "Entrar",
                        style: const TextStyle(
                          color: OrgaliveColors.greenDefault,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: OrgaliveColors.greyBackground,
                        padding: const EdgeInsets.symmetric( horizontal: 12, vertical: 12 ),
                        side: const BorderSide(
                          color: OrgaliveColors.greenDefault,
                          width: 3,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        );

      },
    );
  }
}