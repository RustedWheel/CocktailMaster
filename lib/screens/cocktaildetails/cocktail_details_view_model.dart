import 'package:cocktail_master/models/cocktail.dart';
import 'package:cocktail_master/models/dao/cocktail_dao.dart';
import 'package:flutter/cupertino.dart';

class CocktailDetailsViewModel extends ChangeNotifier {

  CocktailDAO cocktailDAO;

  late String cocktailId;
  late Cocktail cocktail;
  List<String> instructions = [];

  CocktailDetailsViewModel(this.cocktailDAO);

  void fetchCocktailDetails(String id) {
    cocktailId = id;
    cocktail = cocktailDAO.getCocktail(cocktailId);
    instructions = cocktail.getInstructions();
  }

  void setFavorite() {
    cocktailDAO.setFavourite(cocktail, !cocktail.isFavourite);
    notifyListeners();
  }

  void updateProvider(dao) {
    cocktailDAO = dao;
    notifyListeners();
  }
}
