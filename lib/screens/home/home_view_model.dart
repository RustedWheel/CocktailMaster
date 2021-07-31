import 'package:async/async.dart';
import 'package:cocktail_master/models/cocktail.dart';
import 'package:cocktail_master/network/network_api_response.dart';
import 'package:cocktail_master/services/cocktail_service.dart';
import 'package:flutter/cupertino.dart';

class HomeScreenViewModel extends ChangeNotifier {
  CocktailService cocktailService;
  List<Cocktail> searchedCocktailDrinks = [];
  List<Cocktail> randomCocktailDrinks = [];
  List<Cocktail> allCocktailDrinks = [];
  String errorMessage = "";
  String searchTerm = "";

  var currentPageNum = "a".codeUnitAt(0);
  var lastPageNum = "z".codeUnitAt(0);

  CancelableOperation? _cancellableOperation;

  HomeScreenViewModel(this.cocktailService);

  void resetAndFetch() {
    currentPageNum = "a".codeUnitAt(0);
    allCocktailDrinks.clear();
    fetchCocktailsWithPagination();
    notifyListeners();
  }

  void fetchCocktailsWithPagination() async {
    if (searchTerm.isNotEmpty) {
      return;
    }

    var hasNextPage = currentPageNum <= lastPageNum;
    if (hasNextPage) {
      NetworkAPIResponse response = await cocktailService
          .fetchCocktails(String.fromCharCode(currentPageNum));

      if (response.isSuccess) {
        if (response.data != null) {
          allCocktailDrinks.addAll(response.data);
        }
      } else {
        switch (response.statusCode) {
          case 400:
            errorMessage = "Error precessing request";
            break;
          case 500:
            errorMessage = "Dead server";
            break;
          default:
            errorMessage = "Oops, Something went wrong";
        }
      }

      notifyListeners();
    }

    currentPageNum++;
  }

  void updateSearchTerm(String value) async {
    searchTerm = value;

    notifyListeners();

    _cancellableOperation?.cancel();

    if (value.isNotEmpty) {
      _cancellableOperation = CancelableOperation.fromFuture(
        searchCocktail(value),
        onCancel: () => {debugPrint('onCancel: $value')},
      );

      _cancellableOperation?.value.whenComplete(() => {
        notifyListeners(),
        debugPrint('done :$value')
      });
    } else {
      searchedCocktailDrinks.clear();
      notifyListeners();
    }
  }

  Future searchCocktail(String value) async {
    NetworkAPIResponse response = await cocktailService.searchCocktail(value);

    if (response.isSuccess) {
      if (response.data != null) {
        searchedCocktailDrinks.clear();

        if (searchTerm.isNotEmpty) {
          searchedCocktailDrinks.addAll(response.data);
        }
      }
    } else {
      switch (response.statusCode) {
        case 400:
          errorMessage = "Error precessing request";
          break;
        case 500:
          errorMessage = "Dead server";
          break;
        default:
          errorMessage = "Oops, Something went wrong";
      }
    }
  }

  void fetchRandomCocktails() async {
    if (randomCocktailDrinks.isNotEmpty) {
      return;
    }
    for (int i = 0; i < 10; i++) {
      NetworkAPIResponse response = await cocktailService.getRandomCocktail();
      if (response.isSuccess && response.data != null) {
        randomCocktailDrinks.add(response.data);
      }
    }

    notifyListeners();
  }
}
