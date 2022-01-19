// pacotes nativos flutter
import 'package:flutter/material.dart';

// import dos modelos
import 'package:orgalive/model/core/styles/orgalive_colors.dart';

// import das telas
import 'package:orgalive/screens/login/login_options.dart';

class Info extends StatelessWidget {
  const Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // ir para o login
    _goToLoginOptions( int type ) {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (builder) => LoginOptions(type: type),
        ),
      );
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [

                // imagem

                // Textos informativos
                const ListTile(
                  title: Text(
                    "Você sabe, tempo é dinheiro",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: OrgaliveColors.whiteSmoke,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.symmetric( vertical: 15 ),
                    child: Text(
                      "Organize seu dinheirinho em poucos minutos e não perca tempo. Tenha "
                      "tudo sob controle no seu celular ou no seu computador!",
                      style: TextStyle(
                        color: OrgaliveColors.whiteSmoke,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only( top: 150 ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: OrgaliveColors.greenDefault,
                      padding: const EdgeInsets.symmetric( vertical: 17, horizontal: 80 ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _goToLoginOptions( 1 );
                    },
                    child: const Text(
                      "Criar uma conta",
                      style: TextStyle(
                        color: OrgaliveColors.whiteSmoke,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric( vertical: 35 ),
                  child: GestureDetector(
                    onTap: () {
                      _goToLoginOptions( 2 );
                    },
                    child: const Text(
                      "Fazer login",
                      style: TextStyle(
                        color: OrgaliveColors.greenDefault,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
