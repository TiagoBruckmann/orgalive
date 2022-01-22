import 'package:flutter/material.dart';

class ModelCategories {

  String? uid;
  IconData? icon;
  String? name;
  String? selected;
  String? valueSpending;
  String? valueLimit;

  ModelCategories( this.uid, this.icon, this.name/*, this.selected, this.valueSpending, this.valueLimit*/ );

  ModelCategories.complete( this.uid, this.icon, this.name /*, this.selected, this.valueSpending, this.valueLimit*/ );

  factory ModelCategories.fromJson(Map<String, dynamic> json) {
    return ModelCategories(
      json["uid"],
      json["icon"],
      json["name"],
      // json["selected"],
      // json["value_spending"],
      // json["value_limit"],
    );
  }

  @override
  String toString() => name!;
}