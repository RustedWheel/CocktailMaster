import 'package:cocktail_master/models/cocktail.dart';
import 'package:cocktail_master/network/network_api.dart';
import 'package:cocktail_master/utils/extensions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cocktail_master/network/network_api_response.dart';

class CocktailService {

  Future<NetworkAPIResponse<List<Cocktail>>> fetchCocktails(String letter) async {
    final response = await http.get(Uri.parse("${NetworkApi.baseUrl}v1/1/search.php?f=$letter"));
    NetworkAPIResponse<List<Cocktail>> apiResponse;
    final statusCode = response.statusCode;
    if (statusCode.isSuccess()) {
      var parsedJson = await json.decode(response.body);
      List<Cocktail> cocktailDrinks = [];
      if (parsedJson['drinks'] != null) {
        parsedJson['drinks'].forEach((v) {
          cocktailDrinks.add(Cocktail.fromJson(v));
        });
      }
      apiResponse = NetworkAPIResponse(
          isSuccess: true,
          statusCode: statusCode,
          raw: response,
          data: cocktailDrinks);
    } else {
      apiResponse = NetworkAPIResponse(
          isSuccess: false, statusCode: statusCode, raw: response);
    }
    return apiResponse;
  }

  Future<NetworkAPIResponse<List<Cocktail>>> searchCocktail(String searchTerm) async {
    final response = await http.get(Uri.parse("${NetworkApi.baseUrl}v1/1/search.php?s=$searchTerm"));
    NetworkAPIResponse<List<Cocktail>> apiResponse;
    final statusCode = response.statusCode;
    if (statusCode.isSuccess()) {
      var parsedJson = await json.decode(response.body);
      List<Cocktail> cocktailDrinks = [];
      if (parsedJson['drinks'] != null) {
        parsedJson['drinks'].forEach((v) {
          cocktailDrinks.add(Cocktail.fromJson(v));
        });
      }
      apiResponse = NetworkAPIResponse(
          isSuccess: true,
          statusCode: statusCode,
          raw: response,
          data: cocktailDrinks);
    } else {
      apiResponse = NetworkAPIResponse(
          isSuccess: false, statusCode: statusCode, raw: response);
    }
    return apiResponse;
  }

  Future<NetworkAPIResponse<Cocktail>> getRandomCocktail() async {
    final response = await http.get(Uri.parse("${NetworkApi.baseUrl}v1/1/random.php"));
    NetworkAPIResponse<Cocktail> apiResponse;
    final statusCode = response.statusCode;
    if (statusCode.isSuccess()) {
      var parsedJson = await json.decode(response.body);

      // Endpoint actually only returns one cocktail drink
      List<Cocktail> cocktailDrinks = [];
      if (parsedJson['drinks'] != null) {
        parsedJson['drinks'].forEach((v) {
          cocktailDrinks.add(Cocktail.fromJson(v));
        });
      }
      var randomCocktailDrink = cocktailDrinks.first;
      apiResponse = NetworkAPIResponse(
          isSuccess: true,
          statusCode: statusCode,
          raw: response,
          data: randomCocktailDrink);
    } else {
      apiResponse = NetworkAPIResponse(
          isSuccess: false, statusCode: statusCode, raw: response);
    }
    return apiResponse;
  }

}
