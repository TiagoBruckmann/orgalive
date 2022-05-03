// pacotes nativos flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

// import dos modelos
import 'package:orgalive/core/firebase/model_firebase.dart';
import 'package:orgalive/core/styles/orgalive_colors.dart';
import 'package:orgalive/model/model_categories.dart';

// import das telas
import 'package:orgalive/screens/widgets/loading_connection.dart';

// gerenciadores de estado
import 'package:orgalive/mobx/connection/connection_mobx.dart';

class CategoriesEssentials extends StatefulWidget {
  const CategoriesEssentials({Key? key}) : super(key: key);

  @override
  _CategoriesEssentialsState createState() => _CategoriesEssentialsState();
}

class _CategoriesEssentialsState extends State<CategoriesEssentials> {

  // variaveis da tela
  final List<ModelCategories> _listCategories = [];
  bool _isLoading =  true;

  // variaveis do banco
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // gerenciadores de estado
  late ConnectionMobx _connectionMobx;

  // buscar categorias
  Future<List<ModelCategories>> _getCategories() async {

    if ( _listCategories.isEmpty && _isLoading == true ) {

      dynamic data = await _db.collection("categories").get();

      List<ModelCategories> list = [];

      for ( dynamic item in data.docs ) {

        ModelCategories modelCategories = ModelCategories(
          item["uid"],
          item["name"],
          item["selected"],
          item["value_spending"],
          item["value_limit"],
          double.parse(item["percentage"].toString()),
        );

        list.add(modelCategories);
      }

      setState(() {
        _listCategories.addAll(list);
        _isLoading = false;
      });

    }

    return _listCategories;
  }

  // ir para o cadastro de uma nova categoria
  _goToNewCategory() {

  }

  _saveCategories() {

  }

  @override
  void initState() {
    super.initState();
    Analytics().sendScreen("essentials-categories");
    _getCategories();
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
            title: const Text("Categorias essenciais"),
            actions: [
              TextButton(
                onPressed: () {
                  _goToNewCategory();
                },
                child: const FaIcon(
                  FontAwesomeIcons.circlePlus,
                  color: OrgaliveColors.whiteSmoke,
                ),
              )
            ],
          ),

          body: ( _connectionMobx.connectionStatus.toString() == "ConnectivityResult.none" )
            ? const LoadingConnection()
            : ListView.builder(
              itemCount: _listCategories.length,
              itemBuilder: ( context, index ) {
                ModelCategories modelCategories = _listCategories[index];

                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Column(
                    children: [

                      ( index == 0 )
                      ? const Padding(
                        padding: EdgeInsets.only( bottom: 15 ),
                        child: Text(
                          "Selecione as categorias que representam seus gastos essenciais",
                          style: TextStyle(
                            color: OrgaliveColors.whiteSmoke,
                            fontSize: 20,
                          ),
                        ),
                      )
                      : const Padding(padding: EdgeInsets.zero,),

                      Card(
                        color: OrgaliveColors.greyDefault,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular( 10 ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only( top: 5, bottom: 5 ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: OrgaliveColors.darkGray,
                              radius: 20,
                              child: FaIcon(
                                FontAwesomeIcons.house,
                                color: OrgaliveColors.bossanova,
                                size: 20,
                              ),
                            ),

                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Text(
                                  modelCategories.name,
                                  style: const TextStyle(
                                    color: OrgaliveColors.whiteSmoke,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),

                                Checkbox(
                                  activeColor: Theme.of(context).secondaryHeaderColor,
                                  value: modelCategories.selected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      modelCategories.selected = !modelCategories.selected;
                                    });
                                  },
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: OrgaliveColors.greyDefault,
            onPressed: () {
              _saveCategories();
            },
            child: const FaIcon(
              FontAwesomeIcons.floppyDisk,
              size: 25,
            ),
          ),
        );

      },
    );
  }
}
