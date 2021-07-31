import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktail_master/common/cocktail_colors.dart';
import 'package:cocktail_master/common/spacing.dart';
import 'package:cocktail_master/common/strings_home.dart';
import 'package:cocktail_master/common/text_styles.dart';
import 'package:cocktail_master/components/persistent_header.dart';
import 'package:cocktail_master/models/cocktail.dart';
import 'package:cocktail_master/screens/cocktaildetails/cocktail_details.dart';
import 'package:cocktail_master/screens/cocktaildetails/cocktail_details_view_model.dart';
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

  final scrollController =  ScrollController();
  final textInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    WidgetsBinding.instance?.addPostFrameCallback(
        (_) => _refreshIndicatorKey.currentState?.show());
  }

  void addToFavourite(Cocktail cocktail) {

  }

  void scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      Provider.of<HomeScreenViewModel>(context, listen: false)
          .fetchCocktailsWithPagination();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<HomeScreenViewModel>();

    Future<void> _fetchCocktailData() async {
      viewModel.fetchRandomCocktails();
      viewModel.resetAndFetch();
      setState(() {});
    }

    return Scaffold(
        body: Container(
            // color: CocktailColors.background1,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [CocktailColors.background16, CocktailColors.background19])),
                    // colors: [CocktailColors.background16, CocktailColors.background17, CocktailColors.background19])),
            child: SafeArea(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: <Widget>[
                    // Add the app bar to the CustomScrollView.
                    SliverAppBar(
                      // backgroundColor: CocktailColors.background1,
                      backgroundColor: Colors.transparent,
                      // title: Text(StringsHome.homeTitle,
                      //     style: TextStyles.header.copyWith(fontSize: 28)),
                      title: Padding(
                        padding: const EdgeInsets.only(right: 32, top: 24, bottom: 8),
                        child: Image.asset("images/cocktail_master.png", color: Colors.white),
                      ),
                      floating: false,
                      expandedHeight: 100,
                      toolbarHeight: 80,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Image.asset("images/ic_cocktail.png", color: Colors.white),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: IconButton(
                              icon: Image.asset("images/saved_favourites.png"),
                              onPressed: () {}),
                        )
                      ],
                    ),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide(
                                      color: CocktailColors.background8,
                                      width: 2)),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide(
                                      color: CocktailColors.background8,
                                      width: 2)),
                              hintText: 'Search drink',
                              hintStyle: TextStyles.body2,
                            suffixIcon: IconButton(
                              onPressed: (){
                                if (textInputController.text.isNotEmpty) {
                                  textInputController.clear();
                                  viewModel.updateSearchTerm("");
                                  setState(() {});
                                }
                              },
                              icon: Icon(Icons.clear, color: viewModel.searchTerm.isNotEmpty ? Colors.white : Colors.transparent),
                            ),
                          ),
                          onChanged: (text) {
                            viewModel.updateSearchTerm(text);
                          },
                        ),
                      ),
                    ),
                    if (viewModel.searchTerm.isEmpty)
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: Spacing.spacing2x,
                              left: Spacing.spacing2x,
                              right: Spacing.spacing2x),
                          child: const Text("Random Selections",
                              style: TextStyles.subheader),
                        ),
                      ),
                    if (viewModel.searchTerm.isEmpty)
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.spacingHalf),
                          height: 242,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: viewModel.randomCocktailDrinks.length,
                              itemBuilder: (context, index) =>
                                  _buildRandomSelectionCardWidget(
                                      viewModel.randomCocktailDrinks[index])),
                        ),
                      ),
                    if (viewModel.searchTerm.isEmpty)
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: Spacing.spacing2x,
                              left: Spacing.spacing2x,
                              right: Spacing.spacing2x),
                          child: const Text("All Drinks",
                              style: TextStyles.subheader),
                        ),
                      ),
                    if (viewModel.searchTerm.isEmpty)
                      _buildCocktailListsWidget(viewModel.allCocktailDrinks)
                    else
                      _buildCocktailListsWidget(
                          viewModel.searchedCocktailDrinks)
                  ],
                ),
                onRefresh: _fetchCocktailData,
              ),
            )));
  }

  Widget _buildCocktailListsWidget(List<Cocktail> cocktails) => SliverPadding(
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
              var cocktail = cocktails[index];
              return _buildCocktailCardWidget(cocktail);
            },
            childCount: cocktails.length,
          ),
        ),
      );

  Widget _buildCocktailCardWidget(Cocktail cocktail) {
    return GestureDetector(
        child: Hero(
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
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          addToFavourite(cocktail);
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
        ),
        onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                          create: (context) =>
                              CocktailDetailsViewModel(cocktail),
                          child: const CocktailDetailsScreen()))
              )
            });
  }

  Widget _buildRandomSelectionCardWidget(Cocktail cocktail) => Container(
      padding: const EdgeInsets.symmetric(
          vertical: Spacing.spacing2x, horizontal: Spacing.spacing1x),
      height: 210,
      width: 165,
      child: GestureDetector(
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
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
              )),
          onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                            create: (context) =>
                                CocktailDetailsViewModel(cocktail),
                            child: const CocktailDetailsScreen())))
              }));

  @override
  void dispose() {
    scrollController.dispose();
    textInputController.dispose();
    super.dispose();
  }
}
