// imports nativos
import 'package:flutter/material.dart';
import 'package:orgalive/model/core/styles/orgalive_colors.dart';

class ModalFixed extends StatelessWidget {

  final int screenActive;
  const ModalFixed({ Key? key, required this.screenActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    _goBackRelease( String type ) {
      Navigator.pop(context, type);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Selecione o lançamento"),
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text(
                "Mensal",
                style: TextStyle(
                  color: OrgaliveColors.silver,
                ),
              ),
              onTap: () => _goBackRelease("Mensal"),
            ),
            ListTile(
              title: const Text(
                "Bimestral",
                style: TextStyle(
                  color: OrgaliveColors.silver,
                ),
              ),
              onTap: () => _goBackRelease("Bimestral"),
            ),
            ListTile(
              title: const Text(
                "Trimestral",
                style: TextStyle(
                  color: OrgaliveColors.silver,
                ),
              ),
              onTap: () => _goBackRelease("Trimestral"),
            ),
            ListTile(
              title: const Text(
                "Semestral",
                style: TextStyle(
                  color: OrgaliveColors.silver,
                ),
              ),
              onTap: () => _goBackRelease("Semestral"),
            ),
            ListTile(
              title: const Text(
                "Anual",
                style: TextStyle(
                  color: OrgaliveColors.silver,
                ),
              ),
              onTap: () => _goBackRelease("Anual"),
            ),
          ],
        ),
      ),
    );
  }
}