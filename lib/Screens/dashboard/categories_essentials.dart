// pacotes nativos flutter
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import dos modelos
import 'package:orgalive/Model/Core/orgalive_colors.dart';
import 'package:orgalive/Model/model_categories.dart';

class CategoriesEssentials extends StatefulWidget {
  const CategoriesEssentials({Key? key}) : super(key: key);

  @override
  _CategoriesEssentialsState createState() => _CategoriesEssentialsState();
}

class _CategoriesEssentialsState extends State<CategoriesEssentials> {

  final List<ModelCategories> _listCategories = [
    ModelCategories(
        id: 1,
        icon: "home",
        name: "Casa",
        selected: true,
    ),
    ModelCategories(
      id: 2,
      icon: "shoppingBag",
      name: "Compras",
      selected: false,
    ),
    ModelCategories(
      id: 3,
      icon: "user",
      name: "Cuidados pessoais",
      selected: false,
    ),
    ModelCategories(
      id: 4,
      icon: "receipt",
      name: "Dívidas e empréstimos",
      selected: true,
    ),
    ModelCategories(
      id: 5,
      icon: "graduationCap",
      name: "Educação",
      selected: true,
    ),
  ];

  _saveCategories() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categorias essenciais"),
      ),

      body: ListView.builder(
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
                          FontAwesomeIcons.home,
                          color: OrgaliveColors.bossanova,
                          size: 20,
                        ),
                      ),

                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text(
                            "${modelCategories.name}",
                            style: const TextStyle(
                                color: OrgaliveColors.whiteSmoke,
                                fontWeight: FontWeight.w500,
                                fontSize: 16
                            ),
                          ),

                          Checkbox(
                            activeColor: Theme.of(context).secondaryHeaderColor,
                            value: modelCategories.selected,
                            onChanged: (bool? value) {
                              setState(() {
                                if ( value == true ) {
                                  modelCategories.selected = true;
                                } else {
                                  modelCategories.selected = false;
                                }
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
        }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: OrgaliveColors.greyDefault,
        onPressed: () {
          _saveCategories();
        },
        child: const FaIcon(
          FontAwesomeIcons.save,
          size: 25,
        ),
      ),
    );
  }
}
