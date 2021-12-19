// pacotes nativos flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import dos modelos
import 'package:orgalive/Model/Core/styles/orgalive_colors.dart';
import 'package:orgalive/Screens/login/email.dart';

class LoginOptions extends StatelessWidget {

  final int type;
  const LoginOptions({ Key? key, required this.type }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // logar com google
    _loginGoogle() {

    }

    // logar com email
    _loginMail() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (builder) => const Email(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric( vertical: 10, horizontal: 16 ),
        child: Center(
          child: Column(
            children: [

              // logo

              // textos
              ListTile(
                title: Text(
                  ( type == 1 )
                  ? "Bem vindo!"
                  : "Bem vindo novamente!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: OrgaliveColors.whiteSmoke,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),

                subtitle: Padding(
                  padding: const EdgeInsets.symmetric( vertical: 15 ),
                  child: Text(
                    ( type == 1 )
                    ? "Cadastre sua conta para começar a controlar seu dinheirinho."
                    : "Acesse sua conta para voltar a controlar seu dinheirinho.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: OrgaliveColors.darkGray,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),

              // login google
              Padding(
                padding: const EdgeInsets.only( bottom: 30 ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: OrgaliveColors.greyBackground,
                    padding: const EdgeInsets.symmetric( horizontal: 20, vertical: 17 ),
                    side: const BorderSide(
                      color: OrgaliveColors.darkGray,
                      width: 3,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _loginGoogle();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [

                      FaIcon(
                        FontAwesomeIcons.google,
                        color: OrgaliveColors.darkGray,
                        size: 25,
                      ),

                      Text(
                        "Continuar com Google",
                        style: TextStyle(
                          color: OrgaliveColors.greenDefault,
                          fontSize: 20,
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              // login email
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: OrgaliveColors.greyBackground,
                  padding: const EdgeInsets.symmetric( horizontal: 20, vertical: 17 ),
                  side: const BorderSide(
                    color: OrgaliveColors.darkGray,
                    width: 3,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  _loginMail();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [

                    FaIcon(
                      FontAwesomeIcons.envelope,
                      color: OrgaliveColors.darkGray,
                      size: 25,
                    ),

                    Text(
                      "Continuar com E-mail",
                      style: TextStyle(
                        color: OrgaliveColors.greenDefault,
                        fontSize: 20,
                      ),
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
