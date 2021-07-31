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
  final cocktailService = CocktailService();
  @override
  Widget build(BuildContext context) {
    // debugPaintSizeEnabled = true;
    return MaterialApp(
        title: StringsHome.homeTitle,
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home:
        ChangeNotifierProvider(
          create: (context) => HomeScreenViewModel(cocktailService),
          child: const HomeScreen(),
        )
    );
  }
}
