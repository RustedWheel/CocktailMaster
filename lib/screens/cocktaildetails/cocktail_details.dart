import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktail_master/common/cocktail_colors.dart';
import 'package:cocktail_master/common/spacing.dart';
import 'package:cocktail_master/common/strings_cocktail_details.dart';
import 'package:cocktail_master/common/text_styles.dart';
import 'package:cocktail_master/models/cocktail.dart';
import 'package:cocktail_master/models/ingredient.dart';
import 'package:cocktail_master/screens/cocktaildetails/cocktail_details_view_model.dart';
import 'package:cocktail_master/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/src/provider.dart';

class CocktailDetailsScreen extends StatelessWidget {
  final String cocktailID;

  const CocktailDetailsScreen({required this.cocktailID, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CocktailDetailsViewModel>()
      ..fetchCocktailDetails(cocktailID);

    return Scaffold(
        body: Stack(
      children: [
        Container(
          color: CocktailColors.background3,
          child: CustomScrollView(slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                Hero(
                    tag: viewModel.cocktail.id,
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          width: double.infinity,
                          imageUrl: viewModel.cocktail.imageUrl,
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
                          fit: BoxFit.fitWidth,
                        ),
                        Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                                width: double.infinity,
                                height: 80,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    CocktailColors.blackTransparent90,
                                    Colors.transparent,
                                  ],
                                )))),
                        Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    CocktailColors.blackTransparent90,
                                    Colors.transparent,
                                  ],
                                )))),
                      ],
                    )),
                Transform(
                  transform: Matrix4.translationValues(0, -24, 0),
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: Spacing.spacing2x,
                        right: Spacing.spacing2x,
                        top: Spacing.spacing2x),
                    decoration: const BoxDecoration(
                        color: CocktailColors.background3,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.0),
                            topRight: Radius.circular(24.0))),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: Spacing.spacing2x),
                            child: Text(viewModel.cocktail.name,
                                style: TextStyles.header),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: Spacing.spacing1x),
                            child: viewModel.cocktail.iba != null
                                ? Text("IBA: ${viewModel.cocktail.iba.valueOf}",
                                    style: TextStyles.body2.copyWith(
                                        color:
                                            CocktailColors.whiteTransparent60))
                                : Container(),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: Spacing.spacing6x),
                            child: _buildCocktailDetails(viewModel.cocktail),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.only(
                        top: Spacing.spacing4x,
                        left: Spacing.spacing2x,
                        right: Spacing.spacing2x),
                    child: Text(
                        StringsCocktailDetails.cocktailDetailsInstructions,
                        style: TextStyles.subheader)),
              ]),
            ),
            _buildInstructions(viewModel.instructions),
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.only(
                    top: Spacing.spacing6x,
                    left: Spacing.spacing2x,
                    right: Spacing.spacing2x),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      const Text(
                          StringsCocktailDetails.cocktailDetailsIngredients,
                          style: TextStyles.subheader),
                      const Spacer(),
                      Text("${viewModel.cocktail.ingredients.length} items",
                          style: TextStyles.body2.copyWith(
                              color: CocktailColors.whiteTransparent60)),
                    ]),
              )
            ])),
            _buildIngredients(viewModel.cocktail.ingredients),
          ]),
        ),
        _buildCustomActionBar(context, viewModel.cocktail)
      ],
    ));
  }

  Widget _buildCocktailDetails(Cocktail cocktail) {
    return IntrinsicHeight(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                  StringsCocktailDetails.cocktailDetailsGlassType.toUpperCase(),
                  style: TextStyles.smallheader,
                  textAlign: TextAlign.center),
              Padding(
                  padding: const EdgeInsets.only(
                      left: Spacing.spacing1x,
                      right: Spacing.spacing1x,
                      top: Spacing.spacing1x),
                  child: Text(cocktail.glass,
                      style: TextStyles.hightlight,
                      textAlign: TextAlign.center)),
            ],
          ),
        ),
        const VerticalDivider(
          color: CocktailColors.whiteTransparent60,
          thickness: 1.0,
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                  StringsCocktailDetails.cocktailDetailsCocktailType
                      .toUpperCase(),
                  style: TextStyles.smallheader,
                  textAlign: TextAlign.center),
              Padding(
                  padding: const EdgeInsets.only(
                      left: Spacing.spacing1x,
                      right: Spacing.spacing1x,
                      top: Spacing.spacing1x),
                  child: Text(cocktail.category,
                      style: TextStyles.hightlight,
                      textAlign: TextAlign.center))
            ],
          ),
        ),
        const VerticalDivider(
          color: CocktailColors.whiteTransparent60,
          thickness: 1.0,
        ),
        Expanded(
            child: Column(
          children: [
            Text(StringsCocktailDetails.cocktailDetailsAlcoholic.toUpperCase(),
                style: TextStyles.smallheader, textAlign: TextAlign.center),
            Padding(
                padding: const EdgeInsets.only(
                    left: Spacing.spacing1x,
                    right: Spacing.spacing1x,
                    top: Spacing.spacing1x),
                child: Text(cocktail.alcoholic,
                    style: TextStyles.hightlight, textAlign: TextAlign.center))
          ],
        )),
      ],
    ));
  }

  Widget _buildInstructions(List<String> instructions) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
          vertical: Spacing.spacing1x, horizontal: Spacing.spacing2x),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Padding(
              padding: const EdgeInsets.only(top: Spacing.spacing1x),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: Spacing.spacing2x),
                    child: Text('0${index + 1}.', style: TextStyles.hightlight),
                  ),
                  Expanded(
                      child: Text(instructions[index], style: TextStyles.body2))
                ],
              ));
        }, childCount: instructions.length),
      ),
    );
  }

  Widget _buildIngredients(List<Ingredient> ingredients) {
    return SliverPadding(
      padding: const EdgeInsets.all(Spacing.spacing2x),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1 / 2,
          crossAxisSpacing: Spacing.spacing2x,
          mainAxisSpacing: Spacing.spacing2x,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            var ingredient = ingredients[index];
            return _buildIngredientCardWidget(ingredient);
          },
          childCount: ingredients.length,
        ),
      ),
    );
  }

  Widget _buildIngredientCardWidget(Ingredient ingredient) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              color: CocktailColors.background10,
              colorBlendMode: BlendMode.dstATop,
              imageUrl:
                  "https://www.thecocktaildb.com/images/ingredients/${ingredient.name}.png",
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
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Text(
                      ingredient.name,
                      style: TextStyles.body3,
                    ))),
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
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: Spacing.spacing1x),
                          title: Text(
                            ingredient.measure,
                            style: TextStyles.body3,
                          ))),
                ))
          ],
        ));
  }

  Widget _buildCustomActionBar(context, Cocktail cocktail) {
    return SafeArea(
        child: SizedBox(
      height: 68,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(Spacing.spacing1x),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(Spacing.spacing1x),
                primary: Colors.black.withOpacity(0.8), // <-- Button color
                onPrimary: Colors.grey.withOpacity(0.8), // <-- Splash color
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(Spacing.spacing1x),
            child: ElevatedButton(
              onPressed: () {
                Provider.of<CocktailDetailsViewModel>(context, listen: false)
                    .setFavorite();
              },
              child: Icon(
                  cocktail.isFavourite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
                primary: Colors.black.withOpacity(0.8), // <-- Button color
                onPrimary: Colors.grey.withOpacity(0.8), // <-- Splash color
              ),
            ),
          )
        ],
      ),
    ));
  }
}
