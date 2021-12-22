class ModelCreditCard {

  String? type;
  String? number;
  String? valid;
  String? cvv;
  String? uid;
  String? document;

  ModelCreditCard( this.type, this.number, this.valid, this.cvv, this.uid, this.document );

  ModelCreditCard.complete( this.type, this.number, this.valid, this.cvv, this.uid, this.document );

  factory ModelCreditCard.fromJson(Map<String, dynamic> json) {
    return ModelCreditCard(
      json["type"],
      json["number"],
      json["valid"],
      json["cvv"],
      json["user_uid"],
      json["document"]
    );
  }

  @override
  String toString() => type!;

}