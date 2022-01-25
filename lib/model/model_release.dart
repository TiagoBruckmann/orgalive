class ModelRelease {

  String? accountId;
  String? category;
  String? date;
  String? description;
  String? document;
  int status = 0;
  String? type;
  String? userUid;
  String? value;

  ModelRelease( this.accountId, this.category, this.date, this.description, this.document, this.status, this.type, this.userUid, this.value );

  ModelRelease.complete( this.accountId, this.category, this.date, this.description, this.document, this.status, this.type, this.userUid, this.value );

  factory ModelRelease.fromJson(Map<String, dynamic> json) {
    return ModelRelease(
      json["account_id"],
      json["category"],
      json["date"],
      json["description"],
      json["document"],
      json["status"],
      json["type"],
      json["user_uid"],
      json["value"],
    );
  }

  @override
  String toString() => description!;
}