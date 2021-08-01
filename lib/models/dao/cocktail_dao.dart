import '../cocktail.dart';

class CocktailDAO {
  List<Cocktail> cocktailDrinks = [];

  List<Cocktail> getAllCocktailDrinks() {
    var list = cocktailDrinks.toList();
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  Cocktail getCocktail(String cocktailId) {
    return cocktailDrinks.firstWhere((element) => element.id == cocktailId);
  }

  void createCocktail(Cocktail cocktail) {
    if (!cocktailDrinks.any((element) => element.id == cocktail.id)) {
      cocktailDrinks.add(cocktail);
    }
  }

  void setFavourite(Cocktail cocktail, bool favourite) {
    cocktailDrinks.firstWhere((element) => element.id == cocktail.id).isFavourite = favourite;
  }

  void clear() {
    cocktailDrinks.clear();
  }

}
