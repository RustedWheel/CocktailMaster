import 'package:hive/hive.dart';

import '../cocktail.dart';

class CocktailDAO {

  final Box<Cocktail> _database;

  CocktailDAO(this._database);

  List<Cocktail> getAllCocktailDrinks() {
    var list = _database.values.toList();
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  List<Cocktail> getFavouriteCocktails() {
    var list = _database.values.where((cocktail) => cocktail.isFavourite).toList();
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  Cocktail? getCocktail(String cocktailId) {
    return _database.get(cocktailId);
  }

  void createCocktail(Cocktail cocktail) {
    var existingCocktail = _database.get(cocktail.id, defaultValue: null);
    if(existingCocktail != null) {
      cocktail.isFavourite = existingCocktail.isFavourite;
      _database.put(cocktail.id, cocktail);
    } else {
      _database.put(cocktail.id, cocktail);
    }
  }

  void setFavourite(String cocktailId, bool favourite) {
    var cocktail = _database.get(cocktailId, defaultValue: null);
    if (cocktail != null) {
      cocktail.isFavourite = favourite;
      _database.put(cocktailId, cocktail);
    }
  }

}
