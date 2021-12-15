// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos modelos
import 'package:orgalive/Model/Core/styles/orgalive_colors.dart';
import 'package:orgalive/Model/Core/styles/app_gradient.dart';

// import das telas
import 'package:orgalive/Screens/profile/settings.dart';
import 'package:orgalive/Screens/profile/profile.dart';

class AppBarProfile extends PreferredSize {

  final BuildContext context;
  final String user;

  AppBarProfile({ Key? key, required this.context, required this.user })
    : super(
    key: key,
    preferredSize: const Size.fromHeight(150),
    child: SizedBox(
      height: 150,
      child: Stack(
        children: [
          Container(
            height: 180,
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(gradient: AppGradients.linear),
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: ListTile(
                leading: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => Settings(
                          user: user,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://ui-avatars.com/api/?name=$user",
                        ),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  user,
                  style: const TextStyle(
                    color: OrgaliveColors.whiteSmoke,
                    fontSize: 18,
                  ),
                ),
                subtitle: SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: OrgaliveColors.greenDefault,
                      padding: const EdgeInsets.symmetric( horizontal: 50, vertical: 10 ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => const Profile(),
                        ),
                      );
                    },
                    child: const Text(
                      "Editar perfil",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

            ),
          ),

        ],
      ),
    ),
  );
}
