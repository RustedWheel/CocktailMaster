import 'package:cocktail_master/models/ingredient.dart';
import 'package:cocktail_master/utils/extensions.dart';
import 'package:hive/hive.dart';

import 'iba.dart';
part 'cocktail.g.dart';

@HiveType(typeId: 1)
class Cocktail {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final IBA? iba;

  @HiveField(4)
  final String alcoholic;

  @HiveField(5)
  final String glass;

  @HiveField(6)
  final String instructions;

  @HiveField(7)
  final String imageUrl;

  @HiveField(8)
  final List<Ingredient> ingredients;

  @HiveField(9)
  bool isFavourite = false;

  Cocktail({
    required this.id,
    required this.name,
    required this.category,
    required this.iba,
    required this.alcoholic,
    required this.glass,
    required this.instructions,
    required this.imageUrl,
    required this.ingredients,
  });


  List<String> getInstructions() {
    return instructions.split(". ");
  }

  void setFavourite(bool favourite) {
    isFavourite = favourite;
  }

  factory Cocktail.fromJson(Map<String, dynamic> json) {
    int ingredientIndex = 1;
    List<Ingredient> ingredients = [];
    while (ingredientIndex >= 1) {
      var ingredientStr = json["strIngredient$ingredientIndex"];
      if (ingredientStr != null) {
        ingredients.add(Ingredient.fromJson(ingredientIndex, json));
      } else {
        break;
      }
      ingredientIndex++;
    }

    IBA? iba;
    switch (json["strIBA"]) {
      case 'Unforgettables':
        iba = IBA.unforgettables;
        break;
      case 'Contemporary Classics':
        iba = IBA.contemporaryClassics;
        break;
      case 'New Era Drinks':
        iba = IBA.newEraDrinks;
        break;
      default:
        iba = null;
    }
    return Cocktail(
      id: json.optString('idDrink'),
      name: json.optString('strDrink'),
      category: json.optString('strCategory'),
      iba: iba,
      alcoholic: json.optString('strAlcoholic'),
      glass: json.optString('strGlass'),
      instructions: json.optString('strInstructions'),
      imageUrl: json.optString('strDrinkThumb'),
      ingredients: ingredients,
    );
  }
}