import 'package:cocktail_master/utils/extensions.dart';
import 'package:hive/hive.dart';
part 'ingredient.g.dart';

@HiveType(typeId: 0)
class Ingredient {

  @HiveField(0)
  final int step;

  @HiveField(1)
  final String name;

  @HiveField(2)
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
