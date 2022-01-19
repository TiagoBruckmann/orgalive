class Users {

  String? uid;
  String? photo;
  String? name;
  String? mail;
  String? password;
  String? yearBirth;

  Users({ this.uid, this.photo, this.name, this.mail, this.password, this.yearBirth });

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      "photo" : photo,
      "name" : name,
      "mail" : mail,
      "yearBirth" : yearBirth,
    };

    return map;

  }
}