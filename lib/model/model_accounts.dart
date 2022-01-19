class ModelAccounts {

  String? uid;
  String? name;
  String? value;
  String? document;

  ModelAccounts( this.uid, this.name, this.value, this.document );

  ModelAccounts.complete( this.uid, this.name, this.value, this.document );

  factory ModelAccounts.fromJson(Map<String, dynamic> json) {
    return ModelAccounts(
      json["user_uid"],
      json["name"],
      json["value"],
      json["document"],
    );
  }

  @override
  String toString() => name!;

}