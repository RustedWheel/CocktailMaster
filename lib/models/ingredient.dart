import 'package:cocktail_master/utils/extensions.dart';

class Ingredient {
  final int step;
  final String name;
  final String measure;

  Ingredient({
    required this.step,
    required this.name,
    required this.measure,
  });

  factory Ingredient.fromJson(int index, Map<String, dynamic> json) {
    return Ingredient(
        step: index,
        name: json.optString('strIngredient$index'),
        measure: json.optString('strMeasure$index'));
  }
}
