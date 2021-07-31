import 'package:cocktail_master/models/ingredient.dart';
import 'package:cocktail_master/utils/extensions.dart';

// For filtering
enum IBA {
  unforgettables,
  contemporaryClassics,
  newEraDrinks
}

class Cocktail {
  final String id;
  final String name;
  final String category;
  final IBA? iba;
  final String alcoholic;
  final String glass;
  final String instructions;
  final String imageUrl;
  final List<Ingredient> ingredients;

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