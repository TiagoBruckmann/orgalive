class ModelAccounts {

  String? uid;
  String? name;
  String? value;

  ModelAccounts(this.name, this.value );

  ModelAccounts.complete( this.name, this.value );

  factory ModelAccounts.fromJson(Map<String, dynamic> json) {
    return ModelAccounts(
      json["name"],
      json["value"],
    );
  }

  @override
  String toString() => name!;

}