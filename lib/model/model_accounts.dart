class ModelAccounts {

  String? uid;
  String? name;
  String? value;
  String? document;
  bool? defaultAccount;

  ModelAccounts( this.uid, this.name, this.value, this.document, this.defaultAccount );

  ModelAccounts.complete( this.uid, this.name, this.value, this.document, this.defaultAccount );

  factory ModelAccounts.fromJson(Map<String, dynamic> json) {
    return ModelAccounts(
      json["user_uid"],
      json["name"],
      json["value"],
      json["document"],
      json["default"],
    );
  }

  @override
  String toString() => name!;

}