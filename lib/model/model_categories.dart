class ModelCategories {

  String uid = "";
  String name = "";
  bool selected = false;
  String valueSpending = "";
  String valueLimit = "";
  double percentage = 0.0;

  ModelCategories( this.uid, this.name, this.selected, this.valueSpending, this.valueLimit, this.percentage );

  factory ModelCategories.fromJson(Map<String, dynamic> json) {
    return ModelCategories(
      json["uid"],
      json["name"],
      json["selected"],
      json["value_spending"],
      json["value_limit"],
      json["percentage"],
    );
  }

  @override
  String toString() => name;
}