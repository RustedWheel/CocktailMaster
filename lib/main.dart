import 'package:cocktail_master/models/cocktail.dart';
import 'package:cocktail_master/models/dao/cocktail_dao.dart';
import 'package:cocktail_master/models/iba.dart';
import 'package:cocktail_master/screens/cocktaildetails/cocktail_details_view_model.dart';
import 'package:cocktail_master/screens/favourites/my_favourite_cocktails_view_model.dart';
import 'package:cocktail_master/screens/home/home_screen.dart';
import 'package:cocktail_master/screens/home/home_view_model.dart';
import 'package:cocktail_master/services/cocktail_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'common/strings_home.dart';
import 'common/theme.dart';
import 'models/ingredient.dart';

const String dataBoxName = "data";

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(CocktailAdapter());
  Hive.registerAdapter(IngredientAdapter());
  Hive.registerAdapter(IBAAdapter());
  final Box<Cocktail> database = await Hive.openBox<Cocktail>(dataBoxName);
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {

  final Box<Cocktail> database;

  MyApp({required this.database});

  @override
  Widget build(BuildContext context) {

    // A better to way to manage dependency would be to use GetIT
    return MultiProvider(
        providers: [
          Provider(create: (_) => CocktailDAO(database)),
          ProxyProvider<CocktailDAO, CocktailService>(
            update: (context, cocktailDAO, cocktailService) =>
                CocktailService(cocktailDAO),
          ),
          ChangeNotifierProxyProvider2<CocktailService, CocktailDAO,
              HomeScreenViewModel>(
            create: (BuildContext context) => HomeScreenViewModel(
                Provider.of<CocktailService>(context, listen: false),
                Provider.of<CocktailDAO>(context, listen: false)),
            update:
                (context, cocktailService, cocktailDAO, homeScreenViewModel) =>
                    homeScreenViewModel != null
                        ? (homeScreenViewModel..updateProvider(cocktailDAO))
                        : HomeScreenViewModel(cocktailService, cocktailDAO),
          ),
          ChangeNotifierProxyProvider<CocktailDAO, CocktailDetailsViewModel>(
            create: (BuildContext context) => CocktailDetailsViewModel(
                Provider.of<CocktailDAO>(context, listen: false)),
            update: (context, cocktailDAO, cocktailDetailsViewModel) =>
                cocktailDetailsViewModel != null
                    ? (cocktailDetailsViewModel..updateProvider(cocktailDAO))
                    : CocktailDetailsViewModel(cocktailDAO),
          ),
          ChangeNotifierProxyProvider<CocktailDAO, MyFavouriteCocktailsViewModel>(
            create: (BuildContext context) => MyFavouriteCocktailsViewModel(
                Provider.of<CocktailDAO>(context, listen: false)),
            update: (context, cocktailDAO, myFavouriteCocktailsViewModel) =>
            myFavouriteCocktailsViewModel != null
                ? (myFavouriteCocktailsViewModel..updateProvider(cocktailDAO))
                : MyFavouriteCocktailsViewModel(cocktailDAO),
          ),
        ],
        child: MaterialApp(
            title: StringsHome.homeTitle,
            debugShowCheckedModeBanner: false,
            theme: appTheme,
            home: HomeScreen()
            ));
  }
}
