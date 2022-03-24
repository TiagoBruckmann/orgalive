// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

// import dos modelos
import 'package:orgalive/model/core/styles/orgalive_colors.dart';

// import das telas
import 'package:orgalive/screens/widgets/loading_connection.dart';

// gerenciadores de estado
import 'package:orgalive/mobx/connection/connection_mobx.dart';

class Personalize extends StatefulWidget {
  const Personalize({Key? key}) : super(key: key);

  @override
  _PersonalizeState createState() => _PersonalizeState();
}

class _PersonalizeState extends State<Personalize> {

  final bool _disabled = false;
  final int _test = 3;

  // gerenciadores de estado
  late ConnectionMobx _connectionMobx;

  _save() {

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
            title: const Text("Exibição geral"),
          ),

          body: ( _connectionMobx.connectionStatus.toString() == "ConnectivityResult.none" )
          ? const LoadingConnection()
          : ReorderableListView(
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
              FontAwesomeIcons.floppyDisk,
              size: 25,
            ),
          ),
        );

      },
    );
  }
}
