import 'dart:convert';

import 'package:cocktail_master/common/cocktail_colors.dart';
import 'package:cocktail_master/common/images.dart';
import 'package:cocktail_master/common/spacing.dart';
import 'package:cocktail_master/common/strings_home.dart';
import 'package:cocktail_master/common/text_styles.dart';
import 'package:cocktail_master/components/card_grid_list.dart';
import 'package:cocktail_master/screens/favourites/my_favourite_cocktails_screen.dart';
import 'package:cocktail_master/components/persistent_header.dart';
import 'package:cocktail_master/models/cocktail.dart';
import 'package:cocktail_master/screens/cocktaildetails/cocktail_details.dart';
import 'package:cocktail_master/screens/home/home_random_selection_cocktail_card.dart';
import 'package:cocktail_master/screens/home/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final scrollController = ScrollController();
  final textInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    WidgetsBinding.instance?.addPostFrameCallback(
        (_) => _refreshIndicatorKey.currentState?.show());
  }

  void addToFavourite(Cocktail cocktail) {
    Provider.of<HomeScreenViewModel>(context, listen: false)
        .onToggleFavorite(cocktail);
  }

  void scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      final viewModel =
          Provider.of<HomeScreenViewModel>(context, listen: false);
      viewModel.fetchCocktailsWithPagination().then((value) => {
            if (viewModel.errorMessage.isNotEmpty)
              {_showToast(context, viewModel.errorMessage)}
          });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<HomeScreenViewModel>();

    Future<void> _fetchCocktailData() async {
      viewModel.resetAndFetch().then((value) => {
            if (viewModel.errorMessage.isNotEmpty)
              {_showToast(context, viewModel.errorMessage)}
          });
      setState(() {});
    }

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
      child: GestureDetector(
        child: SafeArea(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            child: CustomScrollView(
              controller: scrollController,
              slivers: <Widget>[
                // Add the app bar to the CustomScrollView.
                _HomeAppBar(),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: PersistentHeader(
                    widget: TextField(
                      controller: textInputController,
                      style: TextStyles.body2,
                      cursorColor: CocktailColors.whiteTransparent25,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: CocktailColors.background13,
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                                color: CocktailColors.background8, width: 2)),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                                color: CocktailColors.background8, width: 2)),
                        hintText: StringsHome.homeSearchDrink,
                        hintStyle: TextStyles.body2,
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (textInputController.text.isNotEmpty) {
                              textInputController.clear();
                              viewModel.updateSearchTerm("");
                              setState(() {});
                            }
                          },
                          icon: Icon(Icons.clear,
                              color: viewModel.searchTerm.isNotEmpty
                                  ? Colors.white
                                  : Colors.transparent),
                        ),
                      ),
                      onChanged: (text) {
                        viewModel.updateSearchTerm(text);
                      },
                    ),
                  ),
                ),
                if (viewModel.searchTerm.isEmpty)
                  const SliverToBoxAdapter(
                    child: _HomeSectionHeader(StringsHome.homeRandomSelections),
                  ),
                if (viewModel.searchTerm.isEmpty)
                  _HomeRandomSelectionCardList(viewModel.randomCocktailDrinks),
                if (viewModel.searchTerm.isEmpty)
                  const SliverToBoxAdapter(
                    child: _HomeSectionHeader(StringsHome.homeAllDrinks),
                  ),
                if (viewModel.searchTerm.isEmpty)
                  CardGridList(viewModel.allCocktailDrinks, true)
                else
                  CardGridList(viewModel.searchedCocktailDrinks, true),
                if (viewModel.isLoading)
                  SliverToBoxAdapter(
                    child: Container(
                      height: 88,
                      child: const Center(
                        child: SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child:
                                CircularProgressIndicator(color: Colors.white)),
                      ),
                    ),
                  ),
              ],
            ),
            onRefresh: _fetchCocktailData,
          ),
        ),
        onTap: () => {_clearFocus(context)},
      ),
    ));
  }

  void _clearFocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: StringsHome.homeDismiss,
          onPressed: scaffold.hideCurrentSnackBar,
          textColor: Colors.white,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    textInputController.dispose();
    super.dispose();
  }
}

class _HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      title: Padding(
        padding: const EdgeInsets.only(right: 32, top: 24, bottom: 8),
        child: Image.asset(Images.imageCocktailMasterLogo, color: Colors.white),
      ),
      floating: false,
      expandedHeight: 100,
      toolbarHeight: 80,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Image.asset(Images.imageIconCocktail, color: Colors.white),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: IconButton(
              icon: Image.asset(Images.imageIconSavedFavourites),
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyFavouriteCocktailsScreen()))
                    .then((value) =>
                        Provider.of<HomeScreenViewModel>(context, listen: false)
                            .onBack());
              }),
        )
      ],
    );
  }
}

class _HomeSectionHeader extends StatelessWidget {
  final String headerText;

  const _HomeSectionHeader(this.headerText, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          top: Spacing.spacing2x,
          left: Spacing.spacing2x,
          right: Spacing.spacing2x),
      child: Text(headerText, style: TextStyles.subheader),
    );
  }
}

class _HomeRandomSelectionCardList extends StatelessWidget {
  final List<Cocktail> cocktailList;

  const _HomeRandomSelectionCardList(this.cocktailList, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.spacingHalf),
        height: 242,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cocktailList.length,
            itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.symmetric(
                    vertical: Spacing.spacing2x, horizontal: Spacing.spacing1x),
                height: 210,
                width: 165,
                child: GestureDetector(
                    child: HomeRandomSelectionCocktailCardItem(
                        cocktailList[index]),
                    onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CocktailDetailsScreen(
                                      cocktailID: cocktailList[index]
                                          .id))).then((value) =>
                              Provider.of<HomeScreenViewModel>(context,
                                      listen: false)
                                  .onBack())
                        }))),
      ),
    );
  }
}
