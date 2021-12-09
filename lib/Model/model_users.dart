class Users {
  String? name;
  String? mail;
  String? password;

  Users({ this.name, this.mail, this.password });

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      "name" : name,
      "mail" : mail
    };

    return map;

  }
}