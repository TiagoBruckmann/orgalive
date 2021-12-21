class ModelCreditCard {

  String? uid;
  String? type;
  int? number;
  String? valid;
  int? cvv;

  ModelCreditCard( this.type, this.number, this.valid, this.cvv );

  ModelCreditCard.complete( this.type, this.number, this.valid, this.cvv );

  factory ModelCreditCard.fromJson(Map<String, dynamic> json) {
    return ModelCreditCard(
      json["type"],
      json["number"],
      json["valid"],
      json["cvv"],
    );
  }

  @override
  String toString() => type!;

}