import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktail_master/common/cocktail_colors.dart';
import 'package:cocktail_master/common/spacing.dart';
import 'package:cocktail_master/common/text_styles.dart';
import 'package:cocktail_master/models/cocktail.dart';
import 'package:cocktail_master/screens/favourites/my_favourite_cocktails_view_model.dart';
import 'package:cocktail_master/screens/home/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class CocktailCardItem extends StatelessWidget {

  final Cocktail cocktail;
  final bool isHome;

  const CocktailCardItem(this.cocktail, this.isHome, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Hero(
          tag: cocktail.id,
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: cocktail.imageUrl,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Container(
                        color: Colors.grey,
                        child: Center(
                          child: SizedBox(
                              width: 24.0,
                              height: 24.0,
                              child: CircularProgressIndicator(
                                  color: CocktailColors.background1,
                                  value: downloadProgress.progress)),
                        )),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  CocktailColors.blackTransparent90,
                                  Colors.transparent,
                                ],
                              )))),
                  ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.only(
                        left: Spacing.spacing2x, right: 0.0),
                    title: Text(
                      cocktail.name,
                      style: TextStyles.body1,
                    ),
                    trailing: IconButton(
                        icon: Icon(
                          cocktail.isFavourite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (isHome) {
                            Provider.of<HomeScreenViewModel>(context, listen: false).onToggleFavorite(cocktail);
                          } else {
                            Provider.of<MyFavouriteCocktailsViewModel>(context, listen: false).onToggleFavorite(cocktail);
                          }
                        }),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                CocktailColors.blackTransparent90,
                                Colors.transparent,
                              ],
                            )),
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.only(
                                    left: Spacing.spacing2x,
                                    right: Spacing.spacing2x),
                                title: Text(
                                  cocktail.category,
                                  style: TextStyles.body3,
                                ))),
                      ))
                ],
              )),
        );
  }
}