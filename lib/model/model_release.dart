class ModelRelease {

  String? accountId;
  String? category;
  String? date;
  String? description;
  String? document;
  String? type;
  String? userUid;
  num? value;
  int status = 0;

  ModelRelease( this.accountId, this.category, this.date, this.description, this.document, this.type, this.userUid, this.value, this.status );

  ModelRelease.complete( this.accountId, this.category, this.date, this.description, this.document, this.type, this.userUid, this.value, this.status );

  factory ModelRelease.fromJson(Map<String, dynamic> json) {
    return ModelRelease(
      json["account_id"],
      json["category"],
      json["date"],
      json["description"],
      json["document"],
      json["type"],
      json["user_uid"],
      json["value"],
      json["status"],
    );
  }

  @override
  String toString() => description!;
}