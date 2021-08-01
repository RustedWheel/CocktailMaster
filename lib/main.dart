import 'package:cocktail_master/models/dao/cocktail_dao.dart';
import 'package:cocktail_master/screens/cocktaildetails/cocktail_details_view_model.dart';
import 'package:cocktail_master/screens/home/home_screen.dart';
import 'package:cocktail_master/screens/home/home_view_model.dart';
import 'package:cocktail_master/services/cocktail_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'common/strings_home.dart';
import 'common/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // debugPaintSizeEnabled = true;

    // A better to way to manage dependency would be to use GetIT
    return MultiProvider(
        providers: [
          Provider(create: (_) => CocktailDAO()),
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
        ],
        child: MaterialApp(
            title: StringsHome.homeTitle,
            debugShowCheckedModeBanner: false,
            theme: appTheme,
            home: HomeScreen()
            // home: ChangeNotifierProvider(
            //   create: (context) => HomeScreenViewModel(cocktailService),
            //   child: const HomeScreen(),
            // )
            ));
  }
}
