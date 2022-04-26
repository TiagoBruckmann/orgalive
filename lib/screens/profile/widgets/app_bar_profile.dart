// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos modelos
import 'package:orgalive/core/styles/orgalive_colors.dart';
import 'package:orgalive/core/styles/app_gradient.dart';

// import das telas
import 'package:orgalive/screens/profile/settings.dart';
import 'package:orgalive/screens/profile/profile.dart';

class AppBarProfile extends PreferredSize {

  final BuildContext context;
  final String userUid;
  final String photo;
  final String user;

  AppBarProfile({ Key? key, required this.userUid, required this.photo, required this.context, required this.user })
  : super(
    key: key,
    preferredSize: const Size.fromHeight(150),
    child: SizedBox(
      height: 180,
      child: Stack(
        children: [
          Container(
            height: 180,
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(gradient: AppGradients.linear),
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: ListTile(
                leading: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => Settings(
                          userUid: userUid,
                          photo: photo,
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
                          ( photo.isEmpty )
                          ? "https://ui-avatars.com/api/?name=$user"
                          : photo,
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
                          builder: (builder) => Profile(
                            photo: photo,
                            name: user,
                          ),
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
