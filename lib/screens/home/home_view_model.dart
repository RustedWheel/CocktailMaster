import 'package:async/async.dart';
import 'package:cocktail_master/models/cocktail.dart';
import 'package:cocktail_master/models/dao/cocktail_dao.dart';
import 'package:cocktail_master/network/network_api_response.dart';
import 'package:cocktail_master/services/cocktail_service.dart';
import 'package:flutter/cupertino.dart';

class HomeScreenViewModel extends ChangeNotifier {
  CocktailService cocktailService;
  CocktailDAO cocktailDAO;

  List<Cocktail> searchedCocktailDrinks = [];
  List<Cocktail> randomCocktailDrinks = [];
  List<Cocktail> allCocktailDrinks = [];
  String errorMessage = "";
  String searchTerm = "";

  var isLoading = false;

  var currentPageNum = "a".codeUnitAt(0);
  var lastPageNum = "z".codeUnitAt(0);
  var numberOfCocktailDrinks = 0;

  CancelableOperation? _cancellableOperation;

  HomeScreenViewModel(this.cocktailService, this.cocktailDAO) {
    updateCocktailsList();
    notifyListeners();
  }

  Future<void> resetAndFetch() async {
    currentPageNum = "a".codeUnitAt(0);
    randomCocktailDrinks.clear();
    fetchRandomCocktails();
    await fetchCocktailsWithPagination(loadIfMore: false);
    notifyListeners();
  }

  Future<void> fetchCocktailsWithPagination({bool loadIfMore = true}) async {

    if (searchTerm.isNotEmpty || isLoading) {
      return;
    }

    var hasNextPage = currentPageNum <= lastPageNum;
    if (hasNextPage) {

      final currentNumberOfDrinks = numberOfCocktailDrinks;

      debugPrint('fetchCocktailsWithPagination, currentPageNum: $currentPageNum');
      _setLoading(true);

      NetworkAPIResponse response = await cocktailService
          .fetchCocktails(String.fromCharCode(currentPageNum));

      if (response.isSuccess) {
        _setLoading(false);
        errorMessage = "";
        updateCocktailsList();
        notifyListeners();

        debugPrint('fetchCocktailsWithPagination, currentNumberOfDrinks: $currentNumberOfDrinks');
        debugPrint('fetchCocktailsWithPagination, numberOfCocktailDrinks: $numberOfCocktailDrinks');

        currentPageNum++;

        if (loadIfMore && numberOfCocktailDrinks <= currentNumberOfDrinks) {
          debugPrint('fetchCocktailsWithPagination, fetch more');
          await fetchCocktailsWithPagination();
        }
      } else {
        _setLoading(false);
        switch (response.statusCode) {
          case 400:
            errorMessage = "Error precessing request";
            break;
          case 500:
            errorMessage = "Dead server";
            break;
          case null:
            errorMessage = response.error;
            break;
          default:
            errorMessage = "Oops, Something went wrong";
        }
        notifyListeners();
      }
    }
  }

  void _setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
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
      _setLoading(false);
      searchedCocktailDrinks.clear();
      notifyListeners();
    }
  }

  Future searchCocktail(String value) async {

    _setLoading(true);
    NetworkAPIResponse response = await cocktailService.searchCocktail(value);

    if (response.isSuccess) {
      _setLoading(false);
      errorMessage = "";
      if (response.data != null) {
        searchedCocktailDrinks.clear();

        if (searchTerm.isNotEmpty) {
          searchedCocktailDrinks.addAll(response.data);
          updateCocktailsList();
        }
      }
    } else {
      _setLoading(false);
      switch (response.statusCode) {
        case 400:
          errorMessage = "Error precessing request";
          break;
        case 500:
          errorMessage = "Dead server";
          break;
        case null:
          errorMessage = response.error;
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
        updateCocktailsList();
        notifyListeners();
      }
    }
  }

  void updateCocktailsList() {
    allCocktailDrinks = cocktailDAO.getAllCocktailDrinks();
    numberOfCocktailDrinks = allCocktailDrinks.length;
  }

  void onToggleFavorite(Cocktail cocktail) {
    cocktailDAO.setFavourite(cocktail.id, !cocktail.isFavourite);
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
