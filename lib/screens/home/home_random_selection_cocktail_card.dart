import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktail_master/common/cocktail_colors.dart';
import 'package:cocktail_master/common/spacing.dart';
import 'package:cocktail_master/common/text_styles.dart';
import 'package:cocktail_master/models/cocktail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeRandomSelectionCocktailCardItem extends StatelessWidget {
  final Cocktail cocktail;

  const HomeRandomSelectionCocktailCardItem(this.cocktail, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: cocktail.imageUrl,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Container(
                      color: Colors.grey,
                      child: Center(
                        child: SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: CircularProgressIndicator(
                                color: CocktailColors.background1,
                                value: downloadProgress.progress)),
                      )),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        CocktailColors.blackTransparent90,
                        Colors.transparent,
                      ],
                    )))),
            Padding(
              padding: const EdgeInsets.all(Spacing.spacing1x),
              child: Text(
                cocktail.name,
                style: TextStyles.body2,
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    width: double.infinity,
                    height: 30,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        CocktailColors.blackTransparent90,
                        Colors.transparent,
                      ],
                    ))))
          ],
        ));
  }
}
