import 'package:cocktail_master/common/cocktail_colors.dart';
import 'package:flutter/material.dart';

class TextStyles {

  static const header = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 32,
    color: Colors.white,
  );

  static const subheader = TextStyle(
    fontSize: 18,
    color: Colors.white,
  );

  static const smallheader = TextStyle(
    fontSize: 12,
    color: CocktailColors.whiteTransparent60,
  );

  static const body1 = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  static const body2 = TextStyle(
    fontSize: 14,
    color: Colors.white,
  );

  static const body3 = TextStyle(
    fontSize: 12,
    color: Colors.white,
  );

  static const hightlight =TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: CocktailColors.brightYellow,
  );

}