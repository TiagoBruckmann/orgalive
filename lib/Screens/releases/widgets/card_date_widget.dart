// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos modelos
import 'package:orgalive/Model/Core/styles/orgalive_colors.dart';

class CardDateWidget extends StatelessWidget {

  final String? title;
  const CardDateWidget({ Key? key, required this.title }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: OrgaliveColors.bossanova,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Flexible(
              child: Text(
                "$title",
                overflow: TextOverflow.fade,
                style: const TextStyle(
                  fontSize: 17,
                  color: OrgaliveColors.silver,
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
