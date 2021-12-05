class ModelCategories {

  int? id;
  String? icon;
  String? name;
  bool? selected;

  ModelCategories({ this.id, this.icon, this.name, this.selected });

  factory ModelCategories.fromJson(Map<String, dynamic> json) {
    return ModelCategories(
      id: json["id"],
      icon: json["icon"],
      name: json["name"],
      selected: json["selected"],
    );
  }

  @override
  String toString() => name!;
}