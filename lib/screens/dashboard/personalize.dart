// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import dos modelos
import 'package:orgalive/model/core/styles/orgalive_colors.dart';

class Personalize extends StatefulWidget {
  const Personalize({Key? key}) : super(key: key);

  @override
  _PersonalizeState createState() => _PersonalizeState();
}

class _PersonalizeState extends State<Personalize> {

  final bool _disabled = false;
  final int _test = 3;

  _save() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exibição geral"),
      ),

      body: ReorderableListView(
        children: [

          for ( int i = 0; _test > i; i++ )
            Padding(
              key: Key("$i"),
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Card(
                color: OrgaliveColors.greyDefault,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular( 10 ),
                ),
                child: ListTile(
                  leading: const FaIcon(
                    FontAwesomeIcons.bars,
                    color: OrgaliveColors.whiteSmoke,
                    size: 20,
                  ),

                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      const Text(
                        "Contas",
                        style: TextStyle(
                          color: OrgaliveColors.whiteSmoke,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),

                      ( _disabled == true )
                      ? const Text(
                        "Desabilitado",
                        style: TextStyle(
                          color: OrgaliveColors.whiteSmoke,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      )
                      : const Padding(padding: EdgeInsets.zero),

                    ],
                  ),
                ),
              ),
            ),
        ],
        onReorder: (int oldIndex, int newIndex) {
          /*
          setState(() {
            var movedList = widget.groups.removeAt(oldIndex);
            widget.groups.insert(newIndex, movedList);

            int order = 1;
            for ( int i = 0; i < widget.groups.length; i++ ) {
              order = i + 1;
              widget.groups[i].order = order;
            }
          });
          */
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: OrgaliveColors.greyDefault,
        onPressed: () {
          _save();
        },
        child:  const FaIcon(
          FontAwesomeIcons.save,
          size: 25,
        ),
      ),
    );
  }
}
