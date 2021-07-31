import 'dart:core';

import 'package:cocktail_master/models/cocktail.dart';

extension JsonParsing on Map {
  dynamic optString(String value) {
    return this[value] ?? "";
  }
  dynamic optBoolean(String value) {
    return this[value] ?? false;
  }
}

extension NetworkStatusValidation on int {
  bool isSuccess() {
    return this >= 200 && this <300;
  }
}

extension IBAToString on IBA?{
  String get valueOf {
    switch (this) {
      case IBA.unforgettables:
        return "Unforgettables";
      case IBA.contemporaryClassics:
        return "Contemporary Classics";
      case IBA.newEraDrinks:
        return "New Era Drinks";
      default:
        return "";
    }
  }
}