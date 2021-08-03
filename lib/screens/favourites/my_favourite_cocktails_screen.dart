import 'package:cocktail_master/common/cocktail_colors.dart';
import 'package:cocktail_master/common/text_styles.dart';
import 'package:cocktail_master/components/card_grid_list.dart';
import 'package:cocktail_master/screens/favourites/my_favourite_cocktails_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class MyFavouriteCocktailsScreen extends StatefulWidget {
  const MyFavouriteCocktailsScreen({Key? key}) : super(key: key);

  @override
  _MyFavouriteCocktailsScreenState createState() =>
      _MyFavouriteCocktailsScreenState();
}

class _MyFavouriteCocktailsScreenState
    extends State<MyFavouriteCocktailsScreen> {
  @override
  void initState() {
    Provider.of<MyFavouriteCocktailsViewModel>(context, listen: false)
        .rebuildList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<MyFavouriteCocktailsViewModel>();

    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  CocktailColors.background16,
                  CocktailColors.background19
                ])),
            child: SafeArea(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                      backgroundColor: Colors.transparent,
                      title: Text("My Favourite",
                          style: TextStyles.header.copyWith(fontSize: 28)),
                      floating: false,
                      expandedHeight: 80),
                  CardGridList(viewModel.favouriteCocktails, false)
                ],
              ),
            )));
  }
}
