import 'package:cocktail_master/models/cocktail.dart';
import 'package:flutter/cupertino.dart';

class CocktailDetailsViewModel extends ChangeNotifier {

  final Cocktail cocktail;
  List<String> instructions = [];

  CocktailDetailsViewModel(this.cocktail) {
    instructions = cocktail.getInstructions();
  }
}
