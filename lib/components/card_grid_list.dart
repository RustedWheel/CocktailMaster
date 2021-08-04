import 'package:cocktail_master/common/spacing.dart';
import 'package:cocktail_master/models/cocktail.dart';
import 'package:cocktail_master/screens/cocktaildetails/cocktail_details.dart';
import 'package:cocktail_master/screens/favourites/my_favourite_cocktails_view_model.dart';
import 'package:cocktail_master/screens/home/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cocktail_card.dart';

class CardGridList extends StatelessWidget {
  final List<Cocktail> cocktailList;
  final bool isHome;

  const CardGridList(this.cocktailList, this.isHome, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
          vertical: Spacing.spacing2x, horizontal: Spacing.spacing1x),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: Spacing.spacing1x,
          mainAxisSpacing: Spacing.spacing1x,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            var cocktail = cocktailList[index];
            return GestureDetector(
                child: CocktailCardItem(cocktail, isHome),
                onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CocktailDetailsScreen(
                                  cocktailID: cocktail.id))).then((value) {
                        if (isHome) {
                          Provider.of<HomeScreenViewModel>(context,
                                  listen: false)
                              .onBack();
                        } else {
                          Provider.of<MyFavouriteCocktailsViewModel>(context,
                                  listen: false)
                              .onBack();
                        }
                      })
                    });
          },
          childCount: cocktailList.length,
        ),
      ),
    );
  }
}
