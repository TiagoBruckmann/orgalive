// imports nativos
import 'package:flutter/material.dart';

// import dos modelos
import 'package:orgalive/core/styles/orgalive_colors.dart';

class ModalInstallments extends StatelessWidget {

  final int screenActive;
  const ModalInstallments({ Key? key, required this.screenActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selecione o parcelamento"),
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            // mensal
            const ListTile(
              title: Text(
                "Parcelamento mensal",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: OrgaliveColors.whiteSmoke,
                ),
              ),
            ),

            for ( int i = 1; i < 12; i++ )
              ListTile(
                title: Text(
                  ( i == 1 )
                  ? "$i Mês"
                  : "$i Meses",
                  style: const TextStyle(
                    color: OrgaliveColors.silver,
                  ),
                ),
                onTap: () {
                  String installments = "";
                  if ( i == 1 ) {
                    installments = "$i Mês";
                  } else {
                    installments = "$i Meses";
                  }
                  Navigator.pop(context, installments);
                },
              ),

            // anual
            const ListTile(
              title: Text(
                "Parcelamento anual",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: OrgaliveColors.whiteSmoke,
                ),
              ),
            ),

            for ( int i = 1; i < 6; i++ )
              ListTile(
                title: Text(
                  ( i == 1 )
                  ? "$i Ano"
                  : "$i Anos",
                  style: const TextStyle(
                    color: OrgaliveColors.silver,
                  ),
                ),
                onTap: () {
                  String installments = "$i Ano(s)";
                  Navigator.pop(context, installments);
                },
              ),
          ],
        ),
      ),
    );
  }
}