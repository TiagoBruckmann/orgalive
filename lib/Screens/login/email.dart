// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos modelos
import 'package:orgalive/Model/Core/styles/orgalive_colors.dart';
import 'package:orgalive/Model/model_users.dart';

class Email extends StatefulWidget {
  const Email({Key? key}) : super(key: key);

  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {

  // variaveis da tela
  final TextEditingController _controllerMail = TextEditingController( text: "tiagobruckmann@gmail.com" );
  final TextEditingController _controllerPassword = TextEditingController( text: "teste" );
  String _mensageError = "";
  bool _passwdVisible = false;

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

    if( mail.isNotEmpty && mail.contains("@") && ( mail.contains(".com") || mail.contains(".br") ) ) {

      if( password.isNotEmpty ) {

        setState(() {
          _mensageError = "";
        });

        Users users = Users();
        users.mail = mail;
        users.password = password;

        _clientLogin( users );

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
  _clientLogin( Users users ) async {


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric( horizontal: 16 ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // logo
              /*
              Image.asset(
                AppImages.logo,
                width: 250,
              ),
              */

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
                  labelStyle: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
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
                  child: const Text(
                    "Entrar",
                    style: TextStyle(
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
  }
}