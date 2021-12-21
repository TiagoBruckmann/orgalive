class Users {

  String? photo;
  String? name;
  String? mail;
  String? password;
  String? yearBirth;
  String? genre;

  Users({ this.photo, this.name, this.mail, this.password, this.yearBirth, this.genre });

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      "photo" : photo,
      "name" : name,
      "mail" : mail,
      "yearBirth" : yearBirth,
      "genre" : genre
    };

    return map;

  }
}