// pacotes nativos flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

// import dos modelos
import 'package:orgalive/core/styles/orgalive_colors.dart';
import 'package:orgalive/core/routes/shared_routes.dart';

// import das telas
import 'package:orgalive/screens/widgets/loading_connection.dart';
import 'package:orgalive/screens/widgets/message_widget.dart';

// gerenciadores de estado
import 'package:orgalive/mobx/connection/connection_mobx.dart';

class LoginOptions extends StatelessWidget {

  final int type;
  const LoginOptions({ Key? key, required this.type }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // gerenciadores de estado
    final _connectionMobx = Provider.of<ConnectionMobx>(context);
    _connectionMobx.connectivity.onConnectivityChanged.listen(_connectionMobx.updateConnectionStatus);

    // logar com google
    _loginGoogle() async {

      FirebaseAuth auth = FirebaseAuth.instance;
      User? user;

      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential = await auth.signInWithCredential(credential);

          user = userCredential.user;

          if ( type == 1 ) {

            //Salvar dados do usuário
            FirebaseFirestore db = FirebaseFirestore.instance;

            dynamic data = {
              "uid": user!.uid,
              "photo": user.photoURL,
              "name": user.displayName,
              "mail": user.email,
              "password": "teste",
              "year_birth": null,
            };
            await db.collection("users").doc(user.uid).set(data);

            SharedRoutes().goToHomeRemoveUntil(context);

          } else {

            SharedRoutes().goToHomeRemoveUntil(context);

          }

        } on FirebaseAuthException catch (e) {

          if (e.code == 'account-exists-with-different-credential') {

            CustomSnackBar(
              context,
              "Está conta já existe com diferentes credenciais de login",
              OrgaliveColors.redDefault,
            );

          } else if (e.code == 'invalid-credential') {

            CustomSnackBar(
              context,
              "Erro ao tentar acessar as credenciais, tente novamente",
              OrgaliveColors.redDefault,
            );

          }
        } catch (e) {

          CustomSnackBar(
            context,
            "Erro ao tentar acessar a autenticação do google, tente novamente",
            OrgaliveColors.redDefault,
          );

        }
      }

      return user;

    }

    return Observer(
      builder: (builder){

        return Scaffold(
          appBar: AppBar(),

          body: ( _connectionMobx.connectionStatus.toString() == "ConnectivityResult.none" )
          ? const LoadingConnection()
          : SingleChildScrollView(
            padding: const EdgeInsets.symmetric( vertical: 10, horizontal: 16 ),
            child: Center(
              child: Column(
                children: [

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
                      SharedRoutes().goToLoginMail( context, type );
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

      },
    );
  }
}
