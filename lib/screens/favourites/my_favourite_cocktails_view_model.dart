import 'package:cocktail_master/models/cocktail.dart';
import 'package:cocktail_master/models/dao/cocktail_dao.dart';
import 'package:flutter/cupertino.dart';

class MyFavouriteCocktailsViewModel extends ChangeNotifier {

  CocktailDAO cocktailDAO;
  List<Cocktail> favouriteCocktails = [];

  MyFavouriteCocktailsViewModel(this.cocktailDAO) {
    rebuildList();
  }

  void rebuildList() {
    favouriteCocktails.clear();
    favouriteCocktails.addAll(cocktailDAO.getFavouriteCocktails());
  }

  void onToggleFavorite(Cocktail cocktail) {
    cocktailDAO.setFavourite(cocktail, !cocktail.isFavourite);
    notifyListeners();
  }

  void updateProvider(dao) {
    cocktailDAO = dao;
    notifyListeners();
  }

  void onBack() {
    notifyListeners();
  }
}
